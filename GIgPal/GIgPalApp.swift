//
//  GIgPalApp.swift
//  GIgPal
//
//  Created by Adam on 20/05/2026.
//

import SwiftUI
import SwiftData

@main
struct GIgPalApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                Tab("Discover", systemImage: "music.note.list") {
                    DiscoveryView()
                }
                Tab("My Gigs", systemImage: "ticket") {
                    GigLogView()
                }
                Tab("Stats", systemImage: "chart.bar") {
                    StatsView()
                }
            }
            .preferredColorScheme(.dark)
            .tint(.yellow)
        }
        .modelContainer(for: GigLogEntry.self)
    }
}
