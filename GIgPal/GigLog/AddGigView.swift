import SwiftUI
import SwiftData

struct AddGigView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var artistName = ""
    @State private var venueName = ""
    @State private var venueCity = ""
    @State private var venueCountry = ""
    @State private var showDate = Date()

    private var canSave: Bool {
        !artistName.trimmingCharacters(in: .whitespaces).isEmpty &&
        !venueName.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var body: some View {
        NavigationStack {
            List {
                Section("Show") {
                    TextField("Artist", text: $artistName)
                    DatePicker("Date", selection: $showDate, displayedComponents: .date)
                }

                Section("Venue") {
                    TextField("Venue name", text: $venueName)
                    TextField("City", text: $venueCity)
                    TextField("Country", text: $venueCountry)
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color.black)
            .navigationTitle("Log a Gig")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.black, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .foregroundStyle(.gray)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                        .foregroundStyle(canSave ? .yellow : .gray)
                        .disabled(!canSave)
                }
            }
        }
    }

    private func save() {
        let entry = GigLogEntry(
            artistName: artistName.trimmingCharacters(in: .whitespaces),
            venueName: venueName.trimmingCharacters(in: .whitespaces),
            venueCity: venueCity.trimmingCharacters(in: .whitespaces),
            venueCountry: venueCountry.trimmingCharacters(in: .whitespaces),
            showDate: showDate
        )
        modelContext.insert(entry)
        dismiss()
    }
}
