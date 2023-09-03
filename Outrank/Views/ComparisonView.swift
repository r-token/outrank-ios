//
//  ComparisonView.swift
//  Outrank
//
//  Created by Ryan Token on 10/2/21.
//

import SwiftUI

struct ComparisonView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @State private var teamOne = UserDefaults.standard.string(forKey: "TeamOne") ?? "Tulsa"
    @State private var teamTwo = UserDefaults.standard.string(forKey: "TeamTwo") ?? "SMU"
    
    @State private var teamOneRankings = [String:Int]()
    @State private var teamTwoRankings = [String:Int]()
    
    @State private var isShowingTeamOnePickerView = false
    @State private var isShowingTeamTwoPickerView = false
    @State private var isShowingInfoSheet = false
    @State private var isShowingSortActionSheet = false
    
    @State private var animatingSwap = false
    @State private var apiError = false
    @State private var sortMethod = SortMethods.byStatAlphabetically
    
    enum SortMethods {
        case byStatAlphabetically
        case byStatReverseAlphabetically
        case byRankingAscending
        case byRankingDescending
    }
    
    var sortedTeamOneRankings: [Dictionary<String, Int>.Element]{
        switch sortMethod {
        case SortMethods.byStatAlphabetically:
            return teamOneRankings.sorted{ $0.key < $1.key }
        case SortMethods.byStatReverseAlphabetically:
            return teamOneRankings.sorted{ $0.key > $1.key }
        case SortMethods.byRankingAscending:
            return teamOneRankings.sorted{ $0.value < $1.value }
        case SortMethods.byRankingDescending:
            return teamOneRankings.sorted{ $0.value > $1.value }
        }
    }
    
    var currentSortMethod: String {
        switch sortMethod {
        case SortMethods.byStatAlphabetically:
            return "stat alphabetically"
        case SortMethods.byStatReverseAlphabetically:
            return "stat reverse alphabetically"
        case SortMethods.byRankingAscending:
            return "\(teamOne) ranking ascending"
        case SortMethods.byRankingDescending:
            return "\(teamOne) ranking descending"
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                HStack(alignment: .center) {
                    Button(action: {
                        isShowingTeamOnePickerView = true
                    }) {
                        Text(teamOne)
                    }
                    .buttonStyle(GrowingButton())
                    .accessibilityLabel("\(teamOne), Change Team One")
                    
                    Spacer()
                    
                    Button(action: {
                        swapTeams()
                    }) {
                        Image(systemName: "arrow.left.arrow.right.square")
                            .font(.title)
                            .foregroundColor(.green)
                    }
                    .accessibilityLabel("Swap Teams")
                    
                    
                    Spacer()
                    
                    Button(action: {
                        isShowingTeamTwoPickerView = true
                    }) {
                        Text(teamTwo)
                    }
                    .buttonStyle(GrowingButton())
                    .accessibilityLabel("\(teamTwo), Change Team Two")
                }
                .animation(.default, value: animatingSwap)
                .padding(.top, 5)
                .padding(.horizontal, 25)
                
                HStack {
                    Text("Simple Average: \(Utils.getSimpleAverageFor(teamOneRankings))")
                        .accessibilityLabel("\(teamOne)'s Average Ranking: \(Utils.getSimpleAverageFor(teamOneRankings))")
                    
                    Spacer()
                    
                    Text("Simple Average: \(Utils.getSimpleAverageFor(teamTwoRankings))")
                        .accessibilityLabel("\(teamTwo)'s Average Ranking: \(Utils.getSimpleAverageFor(teamTwoRankings))")
                }
                .foregroundColor(.gray)
                .font(.subheadline)
                .padding(.horizontal, 25)
                .padding(.top, 15)
                
                List {
                    Section(header: Text("Sorted by \(currentSortMethod)")) {
                        ForEach(sortedTeamOneRankings, id: \.self.key) { item in
                            VStack {
                                Text(Conversions.getHumanReadableStat(for: item.key))
                                    .font(.headline)
                                
                                Spacer()
                                
                                HStack {
                                    if item.value < teamTwoRankings[item.key] ?? 99999 {
                                        Text(Conversions.getHumanReadableRanking(for: item.value))
                                            .foregroundColor(.green)
                                    } else if item.value > teamTwoRankings[item.key] ?? 99999 {
                                        Text(Conversions.getHumanReadableRanking(for: item.value))
                                            .foregroundColor(.red)
                                    } else {
                                        Text(Conversions.getHumanReadableRanking(for: item.value))
                                            .foregroundColor(.yellow)
                                    }
                                    
                                    Spacer()
                                    
                                    if item.value > teamTwoRankings[item.key] ?? 99999 {
                                        Text(Conversions.getHumanReadableRanking(for: teamTwoRankings[item.key] ?? 99999))
                                            .foregroundColor(.green)
                                    } else if item.value < teamTwoRankings[item.key] ?? 99999 {
                                        Text(Conversions.getHumanReadableRanking(for: teamTwoRankings[item.key] ?? 99999))
                                            .foregroundColor(.red)
                                    } else {
                                        Text(Conversions.getHumanReadableRanking(for: teamTwoRankings[item.key] ?? 99999))
                                            .foregroundColor(.yellow)
                                    }
                                }
                                .padding(.horizontal)
                                .padding(.vertical, 3)
                            }
                        }
                    }
                    
                    if apiError {
                        Text("😕 Error loading rankings. Please try again or try changing one of the teams.")
                            .foregroundColor(.gray)
                    }
                }
                .listStyle(InsetGroupedListStyle())
                .refreshable {
                    await refreshRankings()
                }
                
                .animation(.default, value: teamOneRankings)
                .animation(.default, value: sortMethod)
            }
            .padding(.top, 10)
            
            .navigationTitle("Compare Teams")
            .navigationBarTitleDisplayMode(.inline)
            
            .toolbar() {
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
            
            .sheet(isPresented: $isShowingTeamOnePickerView) {
                TeamPickerView(team: $teamOne, teamRankings: $teamOneRankings, type: TeamPickerView.TeamPickerTypes.comparisonTeamOne)
            }
            
            .sheet(isPresented: $isShowingTeamTwoPickerView) {
                TeamPickerView(team: $teamTwo, teamRankings: $teamTwoRankings, type: TeamPickerView.TeamPickerTypes.comparisonTeamTwo)
            }
            
            .sheet(isPresented: $isShowingInfoSheet) {
                if #available(iOS 16.0, *) {
                    InfoView(source: Source.compare)
                        .presentationDetents([.medium])
                } else {
                    InfoView(source: Source.compare)

                }
            }
            
            .task {
                if teamOneRankings.isEmpty && teamTwoRankings.isEmpty {
                    await refreshRankings()
                } else {
                    print("We already have comparison data, not fetching onAppear")
                }
            }
        }
        
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    func swapTeams() {
        animatingSwap.toggle()

        let tempTeamOne = teamOne
        let tempTeamTwo = teamTwo
        let tempTeamOneRankings = teamOneRankings
        let tempTeamTwoRankings = teamTwoRankings
        
        teamOne = tempTeamTwo
        teamTwo = tempTeamOne
        teamOneRankings = tempTeamTwoRankings
        teamTwoRankings = tempTeamOneRankings
        
        UserDefaults.standard.set(tempTeamTwo, forKey: "TeamOne")
        UserDefaults.standard.set(tempTeamOne, forKey: "TeamTwo")
        
        HapticGenerator.playWarningHaptic()
    }
    
    func refreshRankings() async {
        do {
            async let teamOneFetched = try TeamFetcher.getTeamRankingsFor(team: teamOne)
            async let teamTwoFetched = try TeamFetcher.getTeamRankingsFor(team: teamTwo)
            
            let rankingsForTeamOne = try await teamOneFetched.allProperties()
            let rankingsForTeamTwo = try await teamTwoFetched.allProperties()
            
            teamOneRankings = rankingsForTeamOne
            teamTwoRankings = rankingsForTeamTwo
            
            apiError = false
        } catch {
            print("Request failed with error: \(error)")
            apiError = true
        }
    }
}

struct ComparisonView_Previews: PreviewProvider {
    static var previews: some View {
        ComparisonView()
    }
}
