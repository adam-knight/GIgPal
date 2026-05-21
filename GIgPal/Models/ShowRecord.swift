import Foundation

struct Show {
    let eventID: String
    let artistName: String
    let venueName: String
    let venueCity: String
    let venueCountry: String
    let date: Date?
    let ticketURL: String?

    static func make(from event: TMEvent, artistName: String) -> Show {
        let venue = event.embedded?.venues?.first
        let date: Date?
        if let dt = event.dates.start.dateTime {
            date = try? Date(dt, strategy: .iso8601)
        } else {
            date = try? Date(event.dates.start.localDate, strategy: .iso8601.year().month().day())
        }
        return Show(
            eventID: event.id,
            artistName: artistName,
            venueName: venue?.name ?? "TBA",
            venueCity: venue?.city.name ?? "",
            venueCountry: venue?.country.name ?? "",
            date: date,
            ticketURL: event.url
        )
    }
}
