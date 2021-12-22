//
//  MyWidget.swift
//  MyWidget
//
//  Created by 孙梁 on 2021/12/18.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    // 提供一个默认的视图，例如网络请求失败、发生未知错误、第一次展示小组件都会展示这个view
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent())
    }
    // 为了在小部件库中显示小部件，WidgetKit要求提供者提供预览快照，在组件的添加页面可以看到效果
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration)
        completion(entry)
    }
    // 在这个方法内可以进行网络请求，拿到的数据保存在对应的entry中，调用completion之后会到刷新小组件
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
}

struct MyWidgetEntryView : View {
    var entry: Provider.Entry
    var type: WidgetFamily
    
    init(entry: Provider.Entry, type: WidgetFamily) {
        self.entry = entry
        self.type = type
    }
    
    var body: some View {
        ZStack {
            type.color
            Text(Date().getCurrentDayStart(true), style: .timer)
                .multilineTextAlignment(.center)
                .font(type.font)
        }
    }
}

extension Date {
    func getCurrentDayStart(_ isDayOf24Hours: Bool)-> Date {
        let calendar:Calendar = Calendar.current;
        let year = calendar.component(.year, from: self);
        let month = calendar.component(.month, from: self);
        let day = calendar.component(.day, from: self);
    
        let components = DateComponents(year: year, month: month, day: day, hour: 0, minute: 0, second: 0)
        return Calendar.current.date(from: components)!
    }
}

extension WidgetFamily {
    var font: Font {
        switch self {
        case .systemSmall:
            return .headline
        case .systemMedium:
            return .title
        case .systemLarge:
            return .largeTitle
        default:
            return .largeTitle
        }
    }
    var color: Color {
        switch self {
        case .systemSmall:
            return .purple
        case .systemMedium:
            return .yellow
        case .systemLarge:
            return .brown
        default:
            return .red
        }
    }
}

//@main
struct MyWidget: Widget {
    var kind: String = "MyWidgetSmall"
    var type: WidgetFamily = .systemSmall
    
    init() {
        
    }
    init(kind: String, type: WidgetFamily) {
        self.kind = kind
        self.type = type
    }
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            MyWidgetEntryView(entry: entry, type: type)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        .supportedFamilies([type])
    }
}

@main   // 把自定的WidgetBundle作为小组件的初始化入口
struct CustomWidgetBundle: WidgetBundle {
    @WidgetBundleBuilder
    var body: some Widget {
        MyWidget(kind: "MyWidgetSmall", type: .systemSmall)
        MyWidget(kind: "MyWidgetMedium", type: .systemMedium)
        MyWidget(kind: "MyWidgetLarge", type: .systemLarge)
    }
}

struct MyWidget_Previews: PreviewProvider {
    static var previews: some View {
        MyWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()), type: .systemSmall)
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
