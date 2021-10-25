//
//  ContentView.swift
//  TeamRankings
//
//  Created by Ryan Token on 10/2/21.
//

import SwiftUI

struct RankingsView: View {
    @State private var currentTeam = UserDefaults.standard.string(forKey: "CurrentTeam") ?? "Air Force"
    @State private var teamRankings = [String:Int]()
    @State private var sortMethod = SortMethods.byStatAlphabetically
    @State private var randomId = UUID()
    @State private var apiError = false
    
    @State private var isShowingTeamPickerView = false
    @State private var isShowingInfoSheet = false
    @State private var isShowingSortActionSheet = false
    
    enum SortMethods {
        case byStatAlphabetically
        case byStatReverseAlphabetically
        case byRankingAscending
        case byRankingDescending
    }
    
    var sortedDictionary: [Dictionary<String, Int>.Element]{
        switch sortMethod {
        case SortMethods.byStatAlphabetically:
            return teamRankings.sorted{ $0.key < $1.key }
        case SortMethods.byStatReverseAlphabetically:
            return teamRankings.sorted{ $0.key > $1.key }
        case SortMethods.byRankingAscending:
            return teamRankings.sorted{ $0.value < $1.value }
        case SortMethods.byRankingDescending:
            return teamRankings.sorted{ $0.value > $1.value }
        }
    }
    
    var currentSortMethod: String {
        switch sortMethod {
        case SortMethods.byStatAlphabetically:
            return "stat alphabetically"
        case SortMethods.byStatReverseAlphabetically:
            return "stat reverse alphabetically"
        case SortMethods.byRankingAscending:
            return "ranking ascending"
        case SortMethods.byRankingDescending:
            return "ranking descending"
        }
    }
    
    init() {
        let tabBarAppearance = UIBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        
        UITabBar.appearance().scrollEdgeAppearance = .init(barAppearance: tabBarAppearance)
    }
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Sorted by \(currentSortMethod)")) {
                    ForEach(sortedDictionary, id: \.self.key) { item in
                        NavigationLink(destination: RankingDetailView(team: currentTeam, stat: item.key, humanReadableStat: Conversions.getHumanReadableStat(for: item.key), ranking: item.value, humanReadableRanking: Conversions.getHumanReadableRanking(for: item.value))) {
                            HStack(alignment: .center, spacing: 8) {
                                Text(Conversions.getHumanReadableStat(for: item.key))
                                    .font(.headline)
                                
                                Spacer()
                                
                                Text(Conversions.getHumanReadableRanking(for: item.value))
                                    .foregroundColor(item.value < 65 ? .green : .red)
                            }
                        }
                    }
                    
                    if apiError {
                        Text("😕 Error loading rankings for \(currentTeam). Please try again or try a different team.")
                            .foregroundColor(.gray)
                    }
                }
            }
            .listStyle(.insetGrouped)
            .refreshable {
                await refreshRankings()
            }
            .animation(.default, value: teamRankings)
            .animation(.default, value: sortMethod)
            
            .navigationTitle(currentTeam)
            
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        isShowingTeamPickerView.toggle()
                    }) {
                        Text("Choose Team")
                            .foregroundColor(.primary)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isShowingInfoSheet.toggle()
                    }) {
                        Image(systemName: "info.circle")
                            .foregroundColor(.primary)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isShowingSortActionSheet.toggle()
                    }) {
                        Image(systemName: "arrow.up.arrow.down")
                            .foregroundColor(.primary)
                    }
                    .actionSheet(isPresented: $isShowingSortActionSheet) {
                        ActionSheet(title: Text("Sort Rankings"), message: Text("Choose a method for sorting the rankings."), buttons: [
                                .default(Text("Sort by stat alphabetically")) {
                                    sortMethod = SortMethods.byStatAlphabetically
                                    HapticGenerator.playSuccessHaptic()
                                },
                                .default(Text("Sort by stat reverse alphabetically")) {
                                    sortMethod = SortMethods.byStatReverseAlphabetically
                                    HapticGenerator.playSuccessHaptic()
                                },
                                .default(Text("Sort by ranking ascending")) {
                                    sortMethod = SortMethods.byRankingAscending
                                    HapticGenerator.playSuccessHaptic()
                                },
                                .default(Text("Sort by ranking descending")) {
                                    sortMethod = SortMethods.byRankingDescending
                                    HapticGenerator.playSuccessHaptic()
                                },
                                .cancel()
                            ]
                        )
                    }
                }
            }
            .id(randomId)
            
            .sheet(isPresented: $isShowingTeamPickerView) {
                TeamPickerView(team: $currentTeam, teamRankings: $teamRankings, type: TeamPickerView.TeamPickerTypes.rankings)
                    .onDisappear {
                        randomId = UUID() // this solves the SwiftUI bug that causes sheets in toolbars to not present consistently
                    }
            }
            
            .sheet(isPresented: $isShowingInfoSheet) {
                InfoView(source: Source.rankings)
                    .onDisappear {
                        randomId = UUID() // this solves the SwiftUI bug that causes sheets in toolbars to not present consistently
                    }
            }
            
            iPadWelcomeView(type: iPadWelcomeView.WelcomeViewType.rankings)
        }
        .accentColor(.primary)
        
        .task {
            if teamRankings.isEmpty {
                await refreshRankings()
            } else {
                print("We already have team data, not fetching onAppear")
            }
        }
    }
    
    func refreshRankings() async {
        Task {
            print("fetching new data")
            do {
                let fetchedRankings = try await TeamFetcher.getTeamRankingsFor(team: currentTeam)
                teamRankings = try fetchedRankings.allProperties()
                apiError = false
            } catch {
                print("Request failed with error: \(error)")
                apiError = true
            }
        }
    }
}

struct SampleSheet: View {
    var body: some View {
        Text("Hello Sheet")
    }
}

struct RankingsView_Previews: PreviewProvider {
    static var previews: some View {
        RankingsView()
    }
}
