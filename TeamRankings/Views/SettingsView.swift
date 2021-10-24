//
//  SettingsView.swift
//  TeamRankings
//
//  Created by Ryan Token on 10/5/21.
//

import SwiftUI
import WidgetKit
import StoreKit

struct SettingsView: View {
    @FetchRequest(entity: Favorite.entity(), sortDescriptors: [], animation: .default) var favorites: FetchedResults<Favorite>
    
    @StateObject var store: Store = Store()
    
    @State private var widgetTeam = UserDefaults(suiteName: "group.com.ryantoken.teamrankings")?.string(forKey: "WidgetTeam") ?? "Air Force"
    @State private var isShowingAboutScreen = false
    
    let allTeams = AllTeams().getTeams()
    
    var selectedCount: Int {
        return favorites.count
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Preferences")) {
                    MultiPicker(
                        label: FavoriteTeamsLabel(),
                        allTeams: allTeams,
                        teamToString: { $0 },
                        selectedCount: selectedCount
                    )
                    
                    Picker(selection: $widgetTeam, label:
                        HStack {
                            Image(systemName: "square.text.square.fill")
                            .font(.title)
                            .foregroundColor(.purple)
                        
                            Text("Widget")
                    }) {
                        ForEach(allTeams, id: \.self) { team in
                            Text(team)
                        }
                    }
                    .onChange(of: widgetTeam) { newWidgetTeam in
                          // Save widget team to App Group userdefaults
                        UserDefaults(suiteName: "group.com.ryantoken.teamrankings")?.set(newWidgetTeam, forKey: "WidgetTeam")
                        WidgetCenter.shared.reloadAllTimelines()
                        
                        print("shared user defaults for widget team is now \(newWidgetTeam)")
                   }
                }
                
                Section(header: Text("Support")) {
                    Button(action: {
                        SKStoreReviewController.requestReviewInCurrentScene()
                    }) {
                        HStack {
                            Image(systemName: "heart.square.fill")
                                .font(.title)
                                .foregroundColor(.red)
                            Text("Rate")
                                .foregroundColor(.primary)
                        }
                    }
                    
                    NavigationLink(destination: TipJarView()) {
                        HStack {
                            Image(systemName: "centsign.square.fill")
                                .font(.title)
                                .foregroundColor(.orange)
                            Text("Leave a Tip")
                        }
                    }
                    .accessibilityLabel("Leave a Tip")
                    
                    NavigationLink(destination: SubscriptionsView()) {
                        HStack {
                            Image(systemName: "dollarsign.square.fill")
                                .font(.title)
                                .foregroundColor(.green)
                            Text("Subscribe")
                        }
                    }
                }
                
                Section(header: Text("General")) {
                    Button(action: {
                        sendFeatureRequestEmail()
                    }) {
                        HStack {
                            Image(systemName: "bolt.square.fill")
                                .font(.title)
                                .foregroundColor(.mint)
                            Text("Feature Request")
                                .foregroundColor(.primary)
                        }
                    }
                    .accessibilityLabel("Send an email with a feature request")
                    
                    Button(action: {
                        isShowingAboutScreen.toggle()
                    }) {
                        HStack {
                            Image(systemName: "person.crop.square.fill")
                                .font(.title)
                                .foregroundColor(.blue)
                            Text("About")
                                .foregroundColor(.primary)
                        }
                    }
                    .accessibilityLabel("About")
                }
            }
            
            .sheet(isPresented: $isShowingAboutScreen) {
                AboutView()
            }
            
            .navigationTitle("Settings")
            
            iPadWelcomeView(type: iPadWelcomeView.WelcomeViewType.settings)
        }
        .environmentObject(store)
    }
    
    func sendFeatureRequestEmail() {
        let email = "teamrankingsapp@gmail.com"
        let subject = "TeamRankings Feature Request"
                    
        let coded = "mailto:\(email)?subject=\(subject)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            
        if let emailURL:NSURL = NSURL(string: coded!) {
            if UIApplication.shared.canOpenURL(emailURL as URL){
                UIApplication.shared.open(emailURL as URL)
            }
       }
    }
}

struct FavoriteTeamsLabel: View {
    var body: some View {
        HStack {
            Image(systemName: "star.square.fill")
                .font(.title)
                .foregroundColor(.yellow)
            Text("Favorites")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
