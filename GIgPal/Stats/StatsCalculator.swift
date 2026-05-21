import Foundation

struct StatsCalculator {
    static func averageRating(from entries: [GigLogEntry]) -> Double? {
        let rated = entries.compactMap(\.rating)
        guard !rated.isEmpty else { return nil }
        return Double(rated.reduce(0, +)) / Double(rated.count)
    }

    static func uniqueCountries(from entries: [GigLogEntry]) -> Int {
        Set(entries.map(\.venueCountry).filter { !$0.isEmpty }).count
    }

    static func topArtists(from entries: [GigLogEntry], limit: Int = 5) -> [(name: String, count: Int)] {
        Dictionary(grouping: entries, by: \.artistName)
            .map { (name: $0.key, count: $0.value.count) }
            .sorted { $0.count > $1.count }
            .prefix(limit).map { $0 }
    }

    static func topVenues(from entries: [GigLogEntry], limit: Int = 5) -> [(name: String, count: Int)] {
        Dictionary(grouping: entries, by: \.venueName)
            .map { (name: $0.key, count: $0.value.count) }
            .sorted { $0.count > $1.count }
            .prefix(limit).map { $0 }
    }

    static func gigsByYear(from entries: [GigLogEntry]) -> [(year: String, count: Int)] {
        var counts: [String: Int] = [:]
        for entry in entries {
            guard let date = entry.showDate else { continue }
            let year = String(Calendar.current.component(.year, from: date))
            counts[year, default: 0] += 1
        }
        return counts.map { (year: $0.key, count: $0.value) }.sorted { $0.year < $1.year }
    }
}
