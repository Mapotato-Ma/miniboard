import SwiftUI

@main
struct MiniBoardApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    private let familyNames = ["systemSmall", "systemMedium", "systemLarge", "systemExtraLarge"]

    var body: some View {
        NavigationStack {
            List {
                Section("这个 App 是干什么的") {
                    Text("它本身的界面不重要，重点是它带了一个**组件扩展**。装好之后，去桌面加它的组件。")
                }

                Section("第一步：验证 iOS 27 的超大组件") {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("1. 长按桌面空白 → 左上角 +")
                        Text("2. 找到「看板」→ 拖一个组件出来")
                        Text("3. 抓住组件右下角的把手，往外拖")
                        Text("4. 能铺满一整屏 = 超大组件成立 🎉")
                    }
                    .font(.callout)
                    Text("组件左上角会显示它当前拿到的尺寸（small / medium / large / extraLarge），那是判断依据。")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }

                Section("第二步：填内容") {
                    Text("先把管道跑通，再往里填东西。下一步是让组件里跑 JavaScriptCore，用 JS 描述界面。")
                        .font(.callout)
                }

                Section("构建信息") {
                    LabeledContent("App 版本", value: Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "-")
                    LabeledContent("构建号", value: Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "-")
                    LabeledContent("支持的组件尺寸", value: familyNames.joined(separator: " / "))
                }
            }
            .navigationTitle("看板")
        }
    }
}

#Preview {
    ContentView()
}
