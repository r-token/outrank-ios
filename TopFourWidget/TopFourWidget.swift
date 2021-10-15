//
//  TopFourWidget.swift
//  TopFourWidget
//
//  Created by Ryan Token on 10/3/21.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        // update at 9:00am daily
        let now = Date()
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.year = calendar.component(.year, from: now)
        dateComponents.month = calendar.component(.month, from: now)
        dateComponents.day = calendar.component(.day, from: now) + 1
        dateComponents.hour = 9
        dateComponents.minute = 0
        dateComponents.second = 0
        let nextUpdate = calendar.date(from: dateComponents)
        
        let entries: [SimpleEntry] = [SimpleEntry(date: now)]
        
        let timeline = Timeline(entries: entries, policy: .after(nextUpdate!))
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct TopFourWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        TopFourView()
    }
}

@main
struct TopFourWidget: Widget {
    let kind: String = "TopFourWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            TopFourWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Top Four Rankings")
        .description("The four stats where a team ranks the highest")
        .supportedFamilies([.systemMedium])
    }
}

struct TopFourWidget_Previews: PreviewProvider {
    static var previews: some View {
        TopFourWidgetEntryView(entry: SimpleEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
