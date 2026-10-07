import WidgetKit
import SwiftUI

// ─────────────────────────────────────────────
//  组件入口
// ─────────────────────────────────────────────

struct BoardEntry: TimelineEntry {
    let date: Date
}

struct BoardProvider: TimelineProvider {
    func placeholder(in context: Context) -> BoardEntry {
        BoardEntry(date: .now)
    }

    func getSnapshot(in context: Context, completion: @escaping (BoardEntry) -> Void) {
        completion(BoardEntry(date: .now))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<BoardEntry>) -> Void) {
        let entry = BoardEntry(date: .now)
        // 每 15 分钟刷新一次；时钟靠 Text 的自动更新，不需要频繁重绘
        let next = Calendar.current.date(byAdding: .minute, value: 15, to: .now) ?? .now.addingTimeInterval(900)
        completion(Timeline(entries: [entry], policy: .after(next)))
    }
}

struct MiniBoardWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "MiniBoardWidget", provider: BoardProvider()) { entry in
            BoardWidgetView(entry: entry)
        }
        .configurationDisplayName("看板")
        .description("占满整屏的自定义看板")
        // ★ iOS 27 的 4×6 超大组件在 iPhone 上是**新的一族**：systemExtraLargePortrait。
        //   老的 systemExtraLarge 是 iPad 横向那个，在 iPhone 上不会被系统采纳 ——
        //   2026-10-07 实测：只声明 systemExtraLarge 时，桌面组件最多只能拖到 large。
        //   它标着 iOS 27.0+，而 deployment target 是 17.0，所以必须用 #available 包起来。
        .supportedFamilies(Self.families)
    }

    static var families: [WidgetFamily] {
        var f: [WidgetFamily] = [.systemSmall, .systemMedium, .systemLarge, .systemExtraLarge]
        if #available(iOS 27.0, *) {
            f.append(.systemExtraLargePortrait)   // iPhone 4×6 竖屏超大组件
        }
        return f
    }
}

@main
struct MiniBoardWidgetBundle: WidgetBundle {
    var body: some Widget {
        MiniBoardWidget()
    }
}
