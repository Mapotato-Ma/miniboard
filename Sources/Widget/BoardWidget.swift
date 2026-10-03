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
        // ★ 关键：把 systemExtraLarge 一起声明。
        //   iOS 27 的 4×6 超大组件就靠这一行换来 —— 前提是**用 iOS 27 SDK 编译**。
        .supportedFamilies([
            .systemSmall,
            .systemMedium,
            .systemLarge,
            .systemExtraLarge,
        ])
    }
}

@main
struct MiniBoardWidgetBundle: WidgetBundle {
    var body: some Widget {
        MiniBoardWidget()
    }
}
