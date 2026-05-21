import SwiftUI
import PhotosUI

struct GigDetailView: View {
    @Bindable var entry: GigLogEntry
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var newSong = ""

    var body: some View {
        List {
            Section {
                if let data = entry.photoData, let image = UIImage(data: data) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity)
                        .frame(height: 220)
                        .clipped()
                        .clipShape(.rect(cornerRadius: 8))
                        .listRowInsets(EdgeInsets())
                }
                PhotosPicker("Choose Photo", selection: $selectedPhoto, matching: .images)
                    .foregroundStyle(.yellow)
            }

            Section {
                LabeledContent("Venue", value: entry.venueName)
                LabeledContent("City", value: "\(entry.venueCity), \(entry.venueCountry)")
                if let date = entry.showDate {
                    LabeledContent("Date", value: date.formatted(date: .long, time: .omitted))
                }
            }

            Section("Rating") {
                StarRatingView(rating: Binding(
                    get: { entry.rating ?? 0 },
                    set: { entry.rating = $0 == 0 ? nil : $0 }
                ))
            }

            Section("Setlist") {
                ForEach(entry.setlist, id: \.self) { song in
                    Text(song)
                }
                .onDelete { entry.setlist.remove(atOffsets: $0) }

                HStack {
                    TextField("Add song", text: $newSong)
                    Button("Add") {
                        let trimmed = newSong.trimmingCharacters(in: .whitespaces)
                        guard !trimmed.isEmpty else { return }
                        entry.setlist.append(trimmed)
                        newSong = ""
                    }
                    .foregroundStyle(.yellow)
                    .disabled(newSong.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }

            Section("Notes") {
                TextField("Add notes…", text: Binding(
                    get: { entry.notes ?? "" },
                    set: { entry.notes = $0.isEmpty ? nil : $0 }
                ), axis: .vertical)
                .lineLimit(4...)
            }
        }
        .navigationTitle(entry.artistName)
        .navigationBarTitleDisplayMode(.large)
        .toolbarBackground(.black, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .scrollContentBackground(.hidden)
        .background(Color.black)
        .onChange(of: selectedPhoto) { _, item in
            Task {
                if let data = try? await item?.loadTransferable(type: Data.self) {
                    entry.photoData = data
                }
            }
        }
    }
}

private struct StarRatingView: View {
    @Binding var rating: Int

    var body: some View {
        HStack {
            ForEach(1...5, id: \.self) { star in
                Button {
                    rating = star == rating ? 0 : star
                } label: {
                    Image(systemName: star <= rating ? "star.fill" : "star")
                        .foregroundStyle(.yellow)
                        .font(.title2)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.vertical)
    }
}
