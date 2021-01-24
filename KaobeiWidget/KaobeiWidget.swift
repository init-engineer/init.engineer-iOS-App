//
//  KaobeiWidget.swift
//  KaobeiWidget
//
//  Created by horo on 1/24/21.
//  Copyright © 2021 Kantai Developer. All rights reserved.
//

import WidgetKit
import SwiftUI
import KaobeiAPI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> ArticleEntry {
        ArticleEntry(date: Date(), article: "純。靠北工程師")
    }

    func getSnapshot(in context: Context, completion: @escaping (ArticleEntry) -> ()) {
        let entry = ArticleEntry(date: Date(), article: "這很純")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [ArticleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        let request = KBGetArticleList.init(page: 1)
        KaobeiConnection.sendRequest(api: request) { response in
            switch response.result {
            case .success(let list):
                for hourOffset in 0 ..< list.data.count {
                    let entryDate = Calendar.current.date(byAdding: .minute, value: hourOffset * 15, to: currentDate)!
                    let entry = ArticleEntry(date: entryDate, article: list.data[hourOffset].content)
                    entries.append(entry)
                }
                
                let timeline = Timeline(entries: entries, policy: .atEnd)
                completion(timeline)
                break
            case .failure(_):
                entries.append(ArticleEntry(date: Calendar.current.date(byAdding: .minute, value: 1, to: currentDate)!, article: "~~就是不給你看~~"))

                let timeline = Timeline(entries: entries, policy: .atEnd)
                completion(timeline)
                break
            }
        }
    }
}

struct ArticleEntry: TimelineEntry {
    let date: Date
    let article: String
}

struct KaobeiWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            Text(entry.article).foregroundColor(.green)
        }
    }
}

@main
struct KaobeiWidget: Widget {
    let kind: String = "KaobeiWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            KaobeiWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        .supportedFamilies([.systemLarge])
    }
}

/*
 struct KaobeiWidget_Previews: PreviewProvider {
    static var previews: some View {
        KaobeiWidgetEntryView(entry: ArticleEntry(date: Date(), article: "這純純的"))
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
*/
