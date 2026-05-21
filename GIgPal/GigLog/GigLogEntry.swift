import SwiftData
import Foundation

@Model
class GigLogEntry {
    var eventID: String
    var artistName: String
    var venueName: String
    var venueCity: String
    var venueCountry: String
    var showDate: Date?
    var rating: Int?
    var setlist: [String] = []
    var notes: String?
    var photoData: Data?
    var loggedAt: Date = Date.now

    init(artistName: String, venueName: String, venueCity: String, venueCountry: String, showDate: Date) {
        self.eventID = UUID().uuidString
        self.artistName = artistName
        self.venueName = venueName
        self.venueCity = venueCity
        self.venueCountry = venueCountry
        self.showDate = showDate
    }

    init(from show: Show) {
        self.eventID = show.eventID
        self.artistName = show.artistName
        self.venueName = show.venueName
        self.venueCity = show.venueCity
        self.venueCountry = show.venueCountry
        self.showDate = show.date
    }
}
