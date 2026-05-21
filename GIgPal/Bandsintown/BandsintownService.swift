import Foundation

struct TicketmasterService {
    // TODO: Replace mock with real API call once key is available from developer.ticketmaster.com
    private static let apiKey = Secrets.ticketmasterAPIKey

    static func events(for artistName: String) async throws -> [TMEvent] {
        return mockEvents[artistName] ?? []
    }
}

private let mockEvents: [String: [TMEvent]] = [
    "Radiohead": [
        TMEvent(id: "rh-1", url: "https://ticketmaster.com", dates: TMDates(start: TMDateStart(localDate: "2026-07-12", dateTime: "2026-07-12T19:00:00Z")), embedded: TMEventEmbedded(venues: [TMVenue(name: "O2 Arena", city: TMCity(name: "London"), country: TMCountry(name: "United Kingdom"))])),
        TMEvent(id: "rh-2", url: "https://ticketmaster.com", dates: TMDates(start: TMDateStart(localDate: "2026-07-15", dateTime: "2026-07-15T19:00:00Z")), embedded: TMEventEmbedded(venues: [TMVenue(name: "Accor Arena", city: TMCity(name: "Paris"), country: TMCountry(name: "France"))]))
    ],
    "Tame Impala": [
        TMEvent(id: "ti-1", url: "https://ticketmaster.com", dates: TMDates(start: TMDateStart(localDate: "2026-08-03", dateTime: "2026-08-03T20:00:00Z")), embedded: TMEventEmbedded(venues: [TMVenue(name: "Hollywood Bowl", city: TMCity(name: "Los Angeles"), country: TMCountry(name: "United States"))]))
    ],
    "Arctic Monkeys": [
        TMEvent(id: "am-1", url: "https://ticketmaster.com", dates: TMDates(start: TMDateStart(localDate: "2026-06-28", dateTime: "2026-06-28T19:30:00Z")), embedded: TMEventEmbedded(venues: [TMVenue(name: "Finsbury Park", city: TMCity(name: "London"), country: TMCountry(name: "United Kingdom"))]))
    ],
    "The National": [
        TMEvent(id: "tn-1", url: "https://ticketmaster.com", dates: TMDates(start: TMDateStart(localDate: "2026-09-10", dateTime: "2026-09-10T20:00:00Z")), embedded: TMEventEmbedded(venues: [TMVenue(name: "Brooklyn Steel", city: TMCity(name: "New York"), country: TMCountry(name: "United States"))]))
    ],
    "Bon Iver": [
        TMEvent(id: "bi-1", url: "https://ticketmaster.com", dates: TMDates(start: TMDateStart(localDate: "2026-10-05", dateTime: "2026-10-05T20:00:00Z")), embedded: TMEventEmbedded(venues: [TMVenue(name: "Royal Albert Hall", city: TMCity(name: "London"), country: TMCountry(name: "United Kingdom"))]))
    ]
]
