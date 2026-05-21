import SwiftUI
import SwiftData
import Charts

struct StatsView: View {
    @Query private var entries: [GigLogEntry]

    var body: some View {
        NavigationStack {
            Group {
                if entries.isEmpty {
                    ContentUnavailableView("No gigs logged yet", systemImage: "chart.bar")
                        .background(Color.black)
                } else {
                    ScrollView {
                        VStack {
                            HStack {
                                StatCard(value: "\(entries.count)", label: "Gigs")
                                StatCard(
                                    value: StatsCalculator.averageRating(from: entries)
                                        .map { $0.formatted(.number.precision(.fractionLength(1))) + "★" } ?? "—",
                                    label: "Avg Rating"
                                )
                                StatCard(value: "\(StatsCalculator.uniqueCountries(from: entries))", label: "Countries")
                            }
                            .padding(.horizontal)

                            let gigsByYear = StatsCalculator.gigsByYear(from: entries)
                            if !gigsByYear.isEmpty {
                                SectionHeader(title: "Gigs per Year")
                                Chart {
                                    ForEach(gigsByYear, id: \.year) { item in
                                        BarMark(
                                            x: .value("Year", item.year),
                                            y: .value("Gigs", item.count)
                                        )
                                        .foregroundStyle(.yellow)
                                        .cornerRadius(4)
                                    }
                                }
                                .frame(height: 160)
                                .padding(.horizontal)
                                .chartXAxis {
                                    AxisMarks { AxisValueLabel().foregroundStyle(Color.gray) }
                                }
                                .chartYAxis {
                                    AxisMarks {
                                        AxisValueLabel().foregroundStyle(Color.gray)
                                        AxisGridLine().foregroundStyle(Color(.systemGray6))
                                    }
                                }
                                .chartPlotStyle { $0.background(Color.black) }
                            }

                            let topArtists = StatsCalculator.topArtists(from: entries)
                            if !topArtists.isEmpty {
                                SectionHeader(title: "Top Artists")
                                RankList(items: topArtists.map { ($0.name, "\($0.count) gigs") })
                            }

                            let topVenues = StatsCalculator.topVenues(from: entries)
                            if !topVenues.isEmpty {
                                SectionHeader(title: "Top Venues")
                                RankList(items: topVenues.map { ($0.name, "\($0.count) visits") })
                            }
                        }
                        .padding(.vertical)
                    }
                    .background(Color.black)
                }
            }
            .navigationTitle("Stats")
            .toolbarBackground(.black, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
    }
}

private struct StatCard: View {
    let value: String
    let label: String

    var body: some View {
        VStack {
            Text(value)
                .font(.title2.bold())
                .foregroundStyle(.yellow)
            Text(label)
                .font(.caption)
                .foregroundStyle(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical)
        .background(Color(.systemGray6))
        .clipShape(.rect(cornerRadius: 12))
    }
}

private struct SectionHeader: View {
    let title: String

    var body: some View {
        Text(title)
            .font(.headline)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
    }
}

private struct RankList: View {
    let items: [(String, String)]

    var body: some View {
        VStack {
            ForEach(items.enumerated(), id: \.offset) { pair in
                HStack {
                    Text("\(pair.offset + 1)")
                        .font(.caption.bold())
                        .foregroundStyle(.yellow)
                        .frame(width: 20)
                    Text(pair.element.0)
                        .foregroundStyle(.white)
                    Spacer()
                    Text(pair.element.1)
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                }
                .padding(.horizontal)
                .padding(.vertical)
                .background(Color(.systemGray6))
                .clipShape(.rect(cornerRadius: 8))
                .padding(.horizontal)
            }
        }
    }
}
