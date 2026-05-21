import Foundation

struct MusicKitService {
    static func libraryArtists(limit: Int = 25) async throws -> [String] {
        // TODO: Replace with real MusicKit implementation once Apple Developer membership is active
        return [
            "Radiohead", "Tame Impala", "Arctic Monkeys", "The National",
            "Bon Iver", "LCD Soundsystem", "Vampire Weekend", "Arcade Fire",
            "Fleet Foxes", "Sufjan Stevens"
        ]
    }
}
