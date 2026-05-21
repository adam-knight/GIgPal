import SwiftUI
import SwiftData

struct GigLogView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \GigLogEntry.loggedAt, order: .reverse) private var entries: [GigLogEntry]
    @State private var showingAddGig = false
    @State private var searchText = ""
    @State private var minRating: Int? = nil

    private var filteredEntries: [GigLogEntry] {
        entries.filter { entry in
            let matchesSearch = searchText.isEmpty ||
                entry.artistName.localizedStandardContains(searchText) ||
                entry.venueName.localizedStandardContains(searchText) ||
                entry.venueCity.localizedStandardContains(searchText)
            let matchesRating = minRating == nil || (entry.rating ?? 0) >= minRating!
            return matchesSearch && matchesRating
        }
    }

    var body: some View {
        NavigationStack {
            Group {
                if entries.isEmpty {
                    ContentUnavailableView("No gigs logged yet", systemImage: "ticket")
                        .background(Color.black)
                } else if filteredEntries.isEmpty {
                    ContentUnavailableView.search(text: searchText)
                        .background(Color.black)
                } else {
                    List {
                        ForEach(filteredEntries) { entry in
                            NavigationLink(value: entry) {
                                GigLogCard(entry: entry)
                            }
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) {
                                    modelContext.delete(entry)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                    .background(Color.black)
                }
            }
            .navigationTitle("My Gigs")
            .navigationDestination(for: GigLogEntry.self) { entry in
                GigDetailView(entry: entry)
            }
            .searchable(text: $searchText, prompt: "Artist, venue or city")
            .toolbarBackground(.black, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Add Gig", systemImage: "plus") { showingAddGig = true }
                        .foregroundStyle(.yellow)
                }
                ToolbarItem(placement: .topBarLeading) {
                    Menu {
                        Button("Any rating") { minRating = nil }
                        Divider()
                        ForEach(1...5, id: \.self) { stars in
                            Button(String(repeating: "★", count: stars)) { minRating = stars }
                        }
                    } label: {
                        Image(systemName: minRating == nil ? "line.3.horizontal.decrease.circle" : "line.3.horizontal.decrease.circle.fill")
                            .foregroundStyle(.yellow)
                    }
                }
            }
            .sheet(isPresented: $showingAddGig) {
                AddGigView()
            }
        }
    }
}

private struct GigLogCard: View {
    let entry: GigLogEntry

    var body: some View {
        HStack(spacing: 0) {
            Rectangle()
                .fill(.yellow)
                .frame(width: 4)

            VStack(alignment: .leading) {
                HStack {
                    Text(entry.artistName)
                        .font(.headline)
                        .bold()
                        .foregroundStyle(.white)
                    Spacer()
                    if let rating = entry.rating {
                        HStack(spacing: 2) {
                            ForEach(1...5, id: \.self) { star in
                                Image(systemName: star <= rating ? "star.fill" : "star")
                                    .font(.caption2)
                                    .foregroundStyle(.yellow)
                            }
                        }
                    }
                }

                Text(entry.venueName)
                    .font(.subheadline)
                    .foregroundStyle(.gray)

                HStack {
                    Text("\(entry.venueCity), \(entry.venueCountry)")
                    Spacer()
                    if let date = entry.showDate {
                        Text(date.formatted(date: .abbreviated, time: .omitted))
                    }
                }
                .font(.caption)
                .foregroundStyle(.secondary)
            }
            .padding()
        }
        .background(Color(.systemGray6))
        .clipShape(.rect(cornerRadius: 12))
    }
}
