//
//  TopFourWidget.swift
//  TopFourWidget
//
//  Created by Ryan Token on 10/3/21.
//

import WidgetKit
import SwiftUI

struct TopFourProvider: TimelineProvider {
    public typealias Entry = TopFourEntry
    
    func placeholder(in context: Context) -> TopFourEntry {
        do {
            return TopFourEntry(date: Date(), teamRankings: try Team.exampleTeam.allProperties())
        } catch {
            print("error setting placeholder entry")
            return TopFourEntry(date: Date(), teamRankings: ["test":99999])
        }
    }

    func getSnapshot(in context: Context, completion: @escaping (TopFourEntry) -> ()) {
        do {
            let entry = TopFourEntry(date: Date(), teamRankings: try Team.exampleTeam.allProperties())
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
            
            let entry = TopFourEntry(date: now, teamRankings: teamRankings)
            
            let entries = [entry]
            
            //your timeline with one entry that will refresh after given date
            let timeline = Timeline(entries: entries, policy: .after(nextUpdate!))
            completion(timeline)
        }
    }
}

struct TopFourEntry: TimelineEntry {
    let date: Date
    let teamRankings: [String:Int]
}

struct TopFourWidgetEntryView : View {
    var entry: TopFourProvider.Entry

    var body: some View {
        TopOrBottomFourView(type: TopOrBottomFourView.WidgetType.topFour, teamRankings: entry.teamRankings)
    }
}

struct TopFourWidget: Widget {
    let kind: String = "TopFourWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: TopFourProvider()) { entry in
            TopFourWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Top Four Widget")
        .description("A team's top four stats. Change the team in the app's Settings page.")
        .supportedFamilies([.systemMedium])
    }
}

struct TopFourWidget_Previews: PreviewProvider {
    static var previews: some View {
        do {
            return TopFourWidgetEntryView(entry: TopFourEntry(date: Date(), teamRankings: try Team.exampleTeam.allProperties()))
                .previewContext(WidgetPreviewContext(family: .systemMedium))
        } catch {
            return TopFourWidgetEntryView(entry: TopFourEntry(date: Date(), teamRankings: ["test":99999]))
                .previewContext(WidgetPreviewContext(family: .systemMedium))
        }
    }
}

@main
struct TeamRankingsBundle: WidgetBundle {
    @WidgetBundleBuilder
    var body: some Widget {
        TopFourWidget()
        BottomFourWidget()
    }
}
