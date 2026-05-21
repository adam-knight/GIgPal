import SwiftUI
import SwiftData

struct DiscoveryView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var shows: [Show] = []
    @State private var isLoading = false
    @State private var error: String?

    var body: some View {
        NavigationStack {
            Group {
                if isLoading {
                    ProgressView("Finding shows…")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.black)
                } else if let error {
                    ContentUnavailableView(error, systemImage: "exclamationmark.triangle")
                        .background(Color.black)
                } else if shows.isEmpty {
                    ContentUnavailableView("No upcoming shows", systemImage: "music.note")
                        .background(Color.black)
                } else {
                    List {
                        ForEach(shows, id: \.eventID) { show in
                            ShowCard(show: show)
                                .listRowBackground(Color.clear)
                                .listRowSeparator(.hidden)
                                .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                                .swipeActions {
                                    Button("Log Gig", systemImage: "checkmark") {
                                        modelContext.insert(GigLogEntry(from: show))
                                    }
                                    .tint(.yellow)
                                }
                        }
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                    .background(Color.black)
                }
            }
            .navigationTitle("Discover")
            .toolbarBackground(.black, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .task { await load() }
        }
    }

    private func load() async {
        isLoading = true
        defer { isLoading = false }
        do {
            shows = try await DiscoveryService.fetchShows()
        } catch {
            self.error = error.localizedDescription
        }
    }
}

private struct ShowCard: View {
    let show: Show

    var body: some View {
        HStack(spacing: 0) {
            Rectangle()
                .fill(.yellow)
                .frame(width: 4)

            VStack(alignment: .leading) {
                Text(show.artistName)
                    .font(.headline)
                    .bold()
                    .foregroundStyle(.white)

                Text(show.venueName)
                    .font(.subheadline)
                    .foregroundStyle(.gray)

                HStack {
                    Text("\(show.venueCity), \(show.venueCountry)")
                    Spacer()
                    if let date = show.date {
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
