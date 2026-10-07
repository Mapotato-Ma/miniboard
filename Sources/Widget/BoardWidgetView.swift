import SwiftUI
import WidgetKit

// 调试角标：把「当前拿到的组件尺寸」画在组件左上角。
// 这一步的全部意义就是回答一个问题 —— iOS 27 的 4×6 到底给没给到我们。
// 管道验证通过后，把它改成 false 即可。
private let SHOW_FAMILY_BADGE = true

struct BoardWidgetView: View {
    @Environment(\.widgetFamily) private var family
    let entry: BoardEntry

    var body: some View {
        ZStack(alignment: .topLeading) {
            content
            if SHOW_FAMILY_BADGE {
                badge
            }
        }
        .containerBackground(for: .widget) { background }
    }

    // ── 背景 ──
    private var background: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.16, green: 0.12, blue: 0.33),
                    Color(red: 0.08, green: 0.06, blue: 0.17),
                    Color(red: 0.03, green: 0.02, blue: 0.06),
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            RadialGradient(
                colors: [Color(red: 0.49, green: 0.36, blue: 1.0).opacity(0.55), .clear],
                center: UnitPoint(x: 0.88, y: 0.02),
                startRadius: 0,
                endRadius: 320
            )
            RadialGradient(
                colors: [Color(red: 1.0, green: 0.30, blue: 0.55).opacity(0.30), .clear],
                center: UnitPoint(x: 0.02, y: 1.0),
                startRadius: 0,
                endRadius: 330
            )
        }
    }

    // ── 角标 ──
    private var badge: some View {
        Text(familyName)
            .font(.system(size: 10, weight: .semibold, design: .monospaced))
            .foregroundStyle(.white)
            .padding(.horizontal, 7)
            .padding(.vertical, 3)
            .background(.white.opacity(0.18), in: Capsule())
            .padding(10)
    }

    private var familyName: String {
        switch family {
        case .systemSmall: return "small"
        case .systemMedium: return "medium"
        case .systemLarge: return "large"
        case .systemExtraLarge: return "extraLarge ★"
        case .systemExtraLargePortrait: return "extraLargePortrait ★"
        case .accessoryCircular: return "accCircular"
        case .accessoryRectangular: return "accRect"
        case .accessoryInline: return "accInline"
        @unknown default: return "unknown"
        }
    }

    // ── 主内容：按尺寸分档 ──
    private var isSmall: Bool { family == .systemSmall }
    private var isXL: Bool { family == .systemExtraLarge || family == .systemExtraLargePortrait }

    private var clockSize: CGFloat {
        switch family {
        case .systemSmall: return 34
        case .systemMedium: return 42
        case .systemExtraLarge, .systemExtraLargePortrait: return 92
        default: return 56
        }
    }

    private var pad: CGFloat {
        switch family {
        case .systemSmall: return 12
        case .systemExtraLarge, .systemExtraLargePortrait: return 26
        default: return 18
        }
    }

    private var content: some View {
        VStack(alignment: .leading, spacing: isXL ? 18 : 10) {
            HStack(alignment: .firstTextBaseline, spacing: 8) {
                Text(entry.date, format: .dateTime.weekday(.wide))
                    .font(.system(size: isSmall ? 11 : 13, weight: .semibold, design: .rounded))
                    .foregroundStyle(.white.opacity(0.85))
                Text(entry.date, format: .dateTime.month().day())
                    .font(.system(size: isSmall ? 11 : 13, weight: .medium, design: .rounded))
                    .foregroundStyle(.white.opacity(0.5))
                Spacer(minLength: 0)
            }

            Text(entry.date, style: .time)
                .font(.system(size: clockSize, weight: .heavy, design: .rounded))
                .foregroundStyle(.white)
                .minimumScaleFactor(0.6)
                .lineLimit(1)

            if !isSmall {
                Text("管道已跑通 · 接下来把这里换成你的内容")
                    .font(.system(size: 13, weight: .medium, design: .rounded))
                    .foregroundStyle(.white.opacity(0.7))
                    .lineLimit(1)
            }

            if isXL || family == .systemLarge {
                Divider().overlay(Color.white.opacity(0.12))
                placeholderRows
            }

            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding(pad)
    }

    private var placeholderRows: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(0..<(isXL ? 6 : 3), id: \.self) { i in
                HStack(spacing: 12) {
                    Text(["09:30", "11:00", "14:30", "16:00", "19:00", "21:00"][i % 6])
                        .font(.system(size: isXL ? 15 : 12.5, weight: .semibold, design: .rounded))
                        .foregroundStyle(.white.opacity(0.55))
                        .frame(width: isXL ? 58 : 46, alignment: .trailing)
                    RoundedRectangle(cornerRadius: 2)
                        .fill(.white.opacity(0.10))
                        .frame(height: isXL ? 14 : 11)
                }
            }
        }
    }
}
