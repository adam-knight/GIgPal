import Foundation

struct DiscoveryService {
    static func fetchShows() async throws -> [Show] {
        let artists = try await MusicKitService.libraryArtists()
        var shows: [Show] = []

        try await withThrowingTaskGroup(of: [Show].self) { group in
            for artist in artists {
                group.addTask {
                    let events = try await TicketmasterService.events(for: artist)
                    return events.map { Show.make(from: $0, artistName: artist) }
                }
            }
            for try await artistShows in group {
                shows.append(contentsOf: artistShows)
            }
        }

        return shows
            .compactMap { show -> (Show, Date)? in
                guard let date = show.date else { return nil }
                return (show, date)
            }
            .filter { $0.1 >= Date.now }
            .sorted { $0.1 < $1.1 }
            .map { $0.0 }
    }
}
