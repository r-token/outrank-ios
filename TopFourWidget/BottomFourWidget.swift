//
//  BottomFourWidget.swift
//  BottomFourWidgetExtension
//
//  Created by Ryan Token on 10/15/21.
//

import WidgetKit
import SwiftUI

struct BottomFourProvider: TimelineProvider {
    public typealias Entry = BottomFourEntry
    
    func placeholder(in context: Context) -> BottomFourEntry {
        do {
            return BottomFourEntry(date: Date(), teamRankings: try Team.exampleTeam.allProperties())
        } catch {
            print("error setting placeholder entry")
            return BottomFourEntry(date: Date(), teamRankings: ["test":99999])
        }
    }

    func getSnapshot(in context: Context, completion: @escaping (BottomFourEntry) -> ()) {
        do {
            let entry = BottomFourEntry(date: Date(), teamRankings: try Team.exampleTeam.allProperties())
            completion(entry)
        } catch {
            print("error setting snapshot entry")
        }
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        TeamFetcher.dispatchQueueGetTeamRankingsFor(team: UserDefaults(suiteName: "group.com.ryantoken.teamrankings")?.string(forKey: "WidgetTeam") ?? "Air Force") { (teamRankings) in

            // update at 10:00am daily
            let now = Date()
            let calendar = Calendar.current
            var dateComponents = DateComponents()
            dateComponents.year = calendar.component(.year, from: now)
            dateComponents.month = calendar.component(.month, from: now)
            dateComponents.day = calendar.component(.day, from: now) + 1
            dateComponents.hour = 10
            dateComponents.minute = 0
            dateComponents.second = 0
            let nextUpdate = calendar.date(from: dateComponents)
            
            let entry = BottomFourEntry(date: now, teamRankings: teamRankings)
            
            let entries = [entry]
            
            //your timeline with one entry that will refresh after given date
            let timeline = Timeline(entries: entries, policy: .after(nextUpdate!))
            completion(timeline)
        }
    }
}

struct BottomFourEntry: TimelineEntry {
    let date: Date
    let teamRankings: [String:Int]
}

struct BottomFourWidgetEntryView : View {
    var entry: BottomFourProvider.Entry

    var body: some View {
        TopOrBottomFourView(type: TopOrBottomFourView.WidgetType.bottomFour, teamRankings: entry.teamRankings)
    }
}

struct BottomFourWidget: Widget {
    let kind: String = "BottomFourWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: BottomFourProvider()) { entry in
            BottomFourWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Bottom Four Widget")
        .description("A team's bottom four stats. Change the team in the app's Settings page.")
        .supportedFamilies([.systemMedium])
    }
}

struct BottomFourWidget_Previews: PreviewProvider {
    static var previews: some View {
        do {
            return BottomFourWidgetEntryView(entry: BottomFourEntry(date: Date(), teamRankings: try Team.exampleTeam.allProperties()))
                .previewContext(WidgetPreviewContext(family: .systemMedium))
        } catch {
            return BottomFourWidgetEntryView(entry: BottomFourEntry(date: Date(), teamRankings: ["test":99999]))
                .previewContext(WidgetPreviewContext(family: .systemMedium))
        }
    }
}
