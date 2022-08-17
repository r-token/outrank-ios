//
//  TrendsView.swift
//  Outrank
//
//  Created by Ryan Token on 11/7/21.
//

import SwiftUI
import Charts

struct TrendsView: View {
    @State private var selectedTeam = UserDefaults.standard.string(forKey: "TrendsTeam") ?? "Air Force"
    @State private var selectedStat = UserDefaults.standard.string(forKey: "TrendsStat") ?? "RedZoneOffense"
    @State private var selectedDateRange = UserDefaults.standard.string(forKey: "TrendsDateRange") ?? "pastWeek"
    @State private var allTeamRankings = [Team]()
    @State private var filteredTeamRankings = [Team]()
    @State private var apiError = false
    
    let allTeams = AllTeams().getTeams()
    let allStats = AllStats().getStats()
    let dateRanges = [
        "pastWeek",
        "pastMonth",
        "pastSeason",
        "allTime"
    ]
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section {
                        Picker("Team", selection: $selectedTeam) {
                            ForEach(allTeams) { team in
                                Text(team)
                            }
                        }
                        .onReceive([selectedTeam].publisher.first()) { newTeam in
                            UserDefaults.standard.set(newTeam, forKey: "TrendsTeam")
                        }
                        
                        Picker("Stat", selection: $selectedStat) {
                            ForEach(allStats) { stat in
                                Text(Conversions.getHumanReadableStat(for: stat))
                            }
                        }
                        .onReceive([selectedStat].publisher.first()) { newStat in
                            UserDefaults.standard.set(newStat, forKey: "TrendsStat")
                        }
                        
                        Picker("Date Range", selection: $selectedDateRange) {
                            ForEach(dateRanges) { dateRange in
                                Text(Conversions.getHumanReadableDateRange(for: dateRange))
                            }
                        }
                        .onReceive([selectedDateRange].publisher.first()) { newDateRange in
                            UserDefaults.standard.set(newDateRange, forKey: "TrendsDateRange")
                        }
                    }
                }
                
                if #available(iOS 16.0, *) {
                    Chart {
                        ForEach(allTeamRankings) { day in
                            if getRankingForThatDay(rankingsThatDay: day) != 99999 && dateIsInSeason(isoDateString: day.date) {
                                LineMark(
                                    x: .value("Date", day.date),
                                    y: .value("Ranking", getRankingForThatDay(rankingsThatDay: day))
                                )
                                .foregroundStyle(Color(.green))
                                .foregroundStyle(by: .value("Stat", Conversions.getHumanReadableStat(for: selectedStat)))
                                .symbol(by: .value("Stat", Conversions.getHumanReadableStat(for: selectedStat)))
                                .accessibilityLabel(Conversions.getHumanReadableStat(for: selectedStat))
                                .accessibilityValue(String(getRankingForThatDay(rankingsThatDay: day)))
                            }
                        }
                    }
                    .chartXAxis {
                        AxisMarks { value in
                            if selectedDateRange == "pastWeek" {
                                if let monthAndDay = getReadableDateFrom(isoDateString: value.as(String.self) ?? "") {
                                    AxisGridLine()
                                    AxisTick()
                                    AxisValueLabel {
                                        Text(monthAndDay)
                                    }
                                } else {
                                    AxisGridLine()
                                }
                            } else if selectedDateRange == "pastMonth" {
                                if let monthAndDay = getReadableDateFrom(isoDateString: value.as(String.self) ?? "") {
                                    AxisGridLine()
                                    AxisTick()
                                    if let lastChar = monthAndDay.last {
                                        if Int(String(lastChar)) ?? 0 % 2 == 0 {
                                            AxisValueLabel {
                                                Text(monthAndDay)
                                            }
                                        } else {
                                            AxisGridLine()
                                        }
                                    } else {
                                        AxisGridLine()
                                    }
                                } else {
                                    AxisGridLine()
                                }
                            } else if selectedDateRange == "pastSeason" || selectedDateRange == "allTime" {
                                AxisGridLine()
                            }
                        }
                    }
                    
                    .chartYAxis {
                        let gridLineInterval = 10.0 // Grid lines every 10 degrees
                        let labelInterval = 20.0 // But only label every other one
                        AxisMarks(values: .stride(by: gridLineInterval)) { value in
                            AxisGridLine()
                            AxisTick()
                            if let axisValue = value.as(Double.self),
                               axisValue.truncatingRemainder(dividingBy: labelInterval) == 0.0 {
                                AxisValueLabel(String(format: "%2.0f", axisValue))
                            }
                            
                        }
                    }
                    
                    .chartLegend(.hidden)
                    .chartYScale(domain: 0 ... 130)
                    
                    Spacer()
                        .frame(height: 20)
                } else {
                    // Fallback on earlier versions
                }
            }
            
            .navigationTitle("Trends")
        }
        
        .task {
            if allTeamRankings.isEmpty {
                await refreshRankings()
            } else {
                print("We already have trend data, not fetching onAppear")
            }
        }
        
        .onChange(of: selectedTeam) { _ in
            Task {
                await refreshRankings()
            }
        }
        
        .onChange(of: selectedStat) { _ in
            Task {
                await refreshRankings()
            }
        }
        
        .onChange(of: selectedDateRange) { _ in
            Task {
                await refreshRankings()
            }
        }
    }
    
    func refreshRankings() async {
        let isoStringDate = getIsoStringDateBasedOnDateRange()
        
        Task {
            print("fetching new trend data")
            do {
                let fetchedRankings = try await HistoricalFetcher.getHistoricalRankingsFor(team: selectedTeam, isoDate: isoStringDate)
                let rankingsByDate = fetchedRankings.sorted { $0.date < $1.date }
                allTeamRankings = rankingsByDate
                apiError = false
            } catch {
                print("Request failed with error: \(error)")
                apiError = true
            }
        }
    }
    
    func getIsoStringDateBasedOnDateRange() -> String {
        var isoStringDate: String
        
        switch selectedDateRange {
        case "pastWeek":
            let modifiedDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())
            isoStringDate = Date.ISOStringFromDate(date: modifiedDate!)
        case "pastMonth":
            let modifiedDate = Calendar.current.date(byAdding: .day, value: -30, to: Date())
            isoStringDate = Date.ISOStringFromDate(date: modifiedDate!)
        case "pastSeason":
            var components = DateComponents()
            components.month = 9
            components.day = 1
            let modifiedDate = Calendar.current.date(from: components) ?? Date.now
            isoStringDate = Date.ISOStringFromDate(date: modifiedDate)
        case "allTime":
            isoStringDate = "2021-10-30T14:00:00.000Z"
        default:
            isoStringDate = Date.ISOStringFromDate(date: Date.now)
        }
        
        return isoStringDate
    }
    
    func getReadableDateFrom(isoDateString: String) -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions.insert(.withFractionalSeconds)
        let date = formatter.date(from: isoDateString) ?? Date.now
        let calendarDate = Calendar.current.dateComponents([.day, .year, .month], from: date)
        
        // let year = calendarDate.year
        let month = calendarDate.month
        let day = calendarDate.day
        
        return "\(month!)/\(day!)"
    }
    
    func dateIsInSeason(isoDateString: String) -> Bool {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions.insert(.withFractionalSeconds)
        let date = formatter.date(from: isoDateString) ?? Date.now
        let calendarDate = Calendar.current.dateComponents([.day, .year, .month], from: date)

        // let year = calendarDate.year
        let month = calendarDate.month ?? 7
        // let day = calendarDate.day ?? 0

        if month == 1 || month >= 8 {
            return true
        } else {
            return false
        }
    }
    
    func getRankingForThatDay(rankingsThatDay: Team) -> Int {
        for _ in allStats {
            switch selectedStat {
            case "BlockedKicks":
                return rankingsThatDay.BlockedKicks ?? 99999
            case "FewestPenaltiesPerGame":
                return rankingsThatDay.FewestPenaltiesPerGame ?? 99999
            case "FourthDownConversionPctDefense":
                return rankingsThatDay.FourthDownConversionPctDefense ?? 99999
            case "TotalDefense":
                return rankingsThatDay.TotalDefense ?? 99999
            case "TacklesForLossAllowed":
                return rankingsThatDay.TacklesForLossAllowed ?? 99999
            case "KickoffReturnDefense":
                return rankingsThatDay.KickoffReturnDefense ?? 99999
            case "RedZoneOffense":
                return rankingsThatDay.RedZoneOffense ?? 99999
            case "TeamSacks":
                return rankingsThatDay.TeamSacks ?? 99999
            case "BlockedPunts":
                return rankingsThatDay.BlockedPunts ?? 99999
            case "PassesIntercepted":
                return rankingsThatDay.PassesIntercepted ?? 99999
            case "PassingYardsAllowed":
                return rankingsThatDay.PassingYardsAllowed ?? 99999
            case "ThirdDownConversionPct":
                return rankingsThatDay.ThirdDownConversionPct ?? 99999
            case "KickoffReturns":
                return rankingsThatDay.KickoffReturns ?? 99999
            case "FewestPenaltyYardsPerGame":
                return rankingsThatDay.FewestPenaltyYardsPerGame ?? 99999
            case "RushingOffense":
                return rankingsThatDay.RushingOffense ?? 99999
            case "PassesHadIntercepted":
                return rankingsThatDay.PassesHadIntercepted ?? 99999
            case "FirstDownsOffense":
                return rankingsThatDay.FirstDownsOffense ?? 99999
            case "TimeOfPossession":
                return rankingsThatDay.TimeOfPossession ?? 99999
            case "PuntReturns":
                return rankingsThatDay.PuntReturns ?? 99999
            case "BlockedKicksAllowed":
                return rankingsThatDay.BlockedKicksAllowed ?? 99999
            case "FewestPenalties":
                return rankingsThatDay.FewestPenalties ?? 99999
            case "FumblesRecovered":
                return rankingsThatDay.FumblesRecovered ?? 99999
            case "BlockedPuntsAllowed":
                return rankingsThatDay.BlockedPuntsAllowed ?? 99999
            case "RedZoneDefense":
                return rankingsThatDay.RedZoneDefense ?? 99999
            case "PuntReturnDefense":
                return rankingsThatDay.PuntReturnDefense ?? 99999
            case "TurnoversLost":
                return rankingsThatDay.TurnoversLost ?? 99999
            case "NetPunting":
                return rankingsThatDay.NetPunting ?? 99999
            case "FewestPenaltyYards":
                return rankingsThatDay.FewestPenaltyYards ?? 99999
            case "TurnoverMargin":
                return rankingsThatDay.TurnoverMargin ?? 99999
            case "FirstDownsDefense":
                return rankingsThatDay.FirstDownsDefense ?? 99999
            case "TeamTacklesForLoss":
                return rankingsThatDay.TeamTacklesForLoss ?? 99999
            case "RushingDefense":
                return rankingsThatDay.RushingDefense ?? 99999
            case "SacksAllowed":
                return rankingsThatDay.SacksAllowed ?? 99999
            case "TeamPassingEfficiency":
                return rankingsThatDay.TeamPassingEfficiency ?? 99999
            case "WinningPercentage":
                return rankingsThatDay.WinningPercentage ?? 99999
            case "DefensiveTDs":
                return rankingsThatDay.DefensiveTDs ?? 99999
            case "FourthDownConversionPct":
                return rankingsThatDay.FourthDownConversionPct ?? 99999
            case "ScoringDefense":
                return rankingsThatDay.ScoringDefense ?? 99999
            case "ScoringOffense":
                return rankingsThatDay.ScoringOffense ?? 99999
            case "FumblesLost":
                return rankingsThatDay.FumblesLost ?? 99999
            case "TeamPassingEfficiencyDefense":
                return rankingsThatDay.TeamPassingEfficiencyDefense ?? 99999
            case "CompletionPercentage":
                return rankingsThatDay.CompletionPercentage ?? 99999
            case "TotalOffense":
                return rankingsThatDay.TotalOffense ?? 99999
            case "PassingYardsPerCompletion":
                return rankingsThatDay.PassingYardsPerCompletion ?? 99999
            case "PassingOffense":
                return rankingsThatDay.PassingOffense ?? 99999
            case "ThirdDownConversionPctDefense":
                return rankingsThatDay.ThirdDownConversionPctDefense ?? 99999
            case "TurnoversGained":
                return rankingsThatDay.TurnoversGained ?? 99999
            default:
                return 99999
            }
        }
        
        return 99999
    }
}

struct TrendsView_Previews: PreviewProvider {
    static var previews: some View {
        TrendsView()
    }
}
