import Foundation

struct TMResponse: Decodable {
    let embedded: TMEmbedded?

    enum CodingKeys: String, CodingKey {
        case embedded = "_embedded"
    }
}

struct TMEmbedded: Decodable {
    let events: [TMEvent]?
}

struct TMEvent: Decodable {
    let id: String
    let url: String
    let dates: TMDates
    let embedded: TMEventEmbedded?

    enum CodingKeys: String, CodingKey {
        case id, url, dates
        case embedded = "_embedded"
    }
}

struct TMDates: Decodable {
    let start: TMDateStart
}

struct TMDateStart: Decodable {
    let localDate: String
    let dateTime: String?
}

struct TMEventEmbedded: Decodable {
    let venues: [TMVenue]?
}

struct TMVenue: Decodable {
    let name: String
    let city: TMCity
    let country: TMCountry
}

struct TMCity: Decodable {
    let name: String
}

struct TMCountry: Decodable {
    let name: String
}
