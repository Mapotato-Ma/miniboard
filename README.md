# MiniBoard —— 不上架、不买 Mac，自己做一个带超大组件的 iOS App

> 目标：验证一条**完全受制于自己**的链路 —— 从写代码到手机上跑起来，只用公开仓库的免费 CI + 一个 Apple ID。

---

## 这条链路长什么样

```
在这台设备上写 Swift         ← 我（AI）来干
      ↓  git push
GitHub 公开仓库              ← 免费
      ↓  GitHub Actions 的 xcode-27 runner（Xcode 27 + iOS 27 SDK）
      ↓  xcodebuild archive，CODE_SIGNING_ALLOWED=NO
      ↓  产出未签名 MiniBoard.ipa，自动挂到 Release
在 Safari 打开链接下载        ← 文件 App 里就有了
      ↓
SideStore 用你的 Apple ID 本地签名并安装
      ↓
7 天后自动后台续签
```

**花钱的地方：0 元。** 公开仓库的 GitHub 托管 runner（含 macOS）免费；Apple ID 免费；SideStore 免费。

---

## 阶段 0 的唯一目标

**不是**做出一个好看的组件，而是回答三个问题：

1. 这条流水线能不能跑通？
2. 免费 Apple ID 能不能签下**带扩展**的包？（这是最大的未知数）
3. iOS 27 的 4×6 超大组件，自己写的 App 能不能拿到？

所以现在这个组件故意做得很简单，但**左上角有个角标**会实时显示它拿到的尺寸：

| 角标显示 | 含义 |
|---|---|
| `small` / `medium` / `large` | 普通尺寸，说明扩展没打进去或只有 3 档 |
| **`extraLarge ★`** | 🎉 超大组件成立，后面就可以放心往里填内容了 |
| `unknown` | SDK 不对（多半是没用 `xcode-27` runner 编译） |

---

## 一、前置准备（一次性）

### 1. 一台电脑 —— 只在最开始用一次

SideStore 官方流程要求：**首次安装 SideStore 本身** 必须用电脑 + USB 线。之后就再也不用了。

- Windows / macOS / Linux 都行
- 装 **iLoader**：<https://docs.sidestore.io/zh/docs/installation/prerequisites>
- 如果你是 Windows（我们之前用过 `ssh pc` 那台就够）

### 2. 手机上装 LocalDevVPN

App Store 搜 **LocalDevVPN**（SideStore 靠它做本机回环，不需要真连外网）。

### 3. 一个 Apple ID

**建议单独注册一个新的 Apple ID 专门用来侧载**，别用你的主力账号 —— 侧载折腾多了有被风控的风险，隔离一下更稳。这个 ID 不需要加入开发者计划，不需要花 $99。

### 4. 准备一个 GitHub 公开仓库

名字随意，比如 `miniboard`。**必须是 public** —— 私有仓库的 macOS runner 要按分钟计费。

---

## 二、把代码推上去

```bash
# 在能访问 GitHub 的地方（或直接在我这边帮你推）
cd miniboard
git init -b main
git add -A
git commit -m "feat: MiniBoard 骨架 + 超大组件验证"
git remote add origin git@github.com:<你的用户名>/miniboard.git
git push -u origin main
```

推上去之后：

1. 打开仓库的 **Actions** 标签
2. 等 「构建 ipa」这个 workflow 跑完（首次约 5–10 分钟，主要花在装 XcodeGen 上）
3. 跑完点进去，页面最下面有 **下载地址**：

```
https://github.com/<用户名>/miniboard/releases/download/ipa-latest/MiniBoard.ipa
```

**编译失败的话**，把它输出的最后 100 行发我 —— workflow 里已经写好，失败时会自动打印日志尾部。

---

## 三、装 SideStore（只在最初做一次）

1. 把 iPhone 用 USB 线连到电脑，手机上点「信任」
2. 电脑上打开 **iLoader** → 用你那个侧载专用 Apple ID 登录 → 选中你的设备
3. 选 **Install SideStore (Stable)**
4. **手机上**：
   - 设置 → 通用 → VPN 与设备管理 → 找到以你 Apple ID 命名的描述文件 → **信任**
   - 设置 → 隐私与安全性 → 拉到底 → 打开 **开发者模式** → 重启手机
   - 打开 **LocalDevVPN** → Connect
   - 打开 **SideStore** → 用同一个 Apple ID 登录
   - 我的应用 → 点 SideStore 右边那个 **「7 DAYS」** 倒计时 → 手动刷新一次，完成初始化

到这一步 SideStore 就装好了。**以后续签、装新包，全在手机上完成。**

> ⚠️ 以后每次要装/更新/续签之前，**都要先把 LocalDevVPN 连上**。

---

## 四、装我们自己的 ipa

1. 手机 Safari 打开上面那个 Release 下载链接 → 文件存到「文件」App
2. 打开「文件」App，确认 `MiniBoard.ipa` 在 **下载项 / Downloads** 里
3. 打开 **SideStore** → 我的应用 → 右上角 **+** → 选那个 ipa
4. 等它签名 + 安装完成，桌面会出现「看板」这个 App
5. 首次打开如果提示不受信任：设置 → 通用 → VPN 与设备管理 → 信任

---

## 五、验证超大组件（关键一步）

1. 长按桌面空白 → 左上角 **+** → 搜「看板」
2. 拖一个组件到桌面
3. **长按这个组件 → 抓住右下角的把手往外拖**

看组件左上角的角标：

- 出现 **`extraLarge ★`** → 成了，告诉我，下一步开始往里填内容
- 拖不动 / 只有 `large` → 把角标截图给我，我们查 SDK 或 supportedFamilies

---

## 之后怎么迭代

| 阶段 | 内容 | 需要重签吗 |
|---|---|---|
| 0 | 跑通链路 + 拿到超大组件 | — |
| 1 | 组件里跑 **JavaScriptCore**，执行一段 JS 渲染出文字 | 要（改 Swift 就要出新包） |
| 2 | 做 JS API（Stack / Text / Image…）映射到 SwiftUI | 要 |
| 3 | App 里编辑脚本 → 组件立刻生效 | 要，**且需要 App Groups** |

⚠️ **阶段 3 需要 App Groups，而免费账号用不了**。两个选择：

- **绕开**：脚本直接编译进 App 和扩展两个 target，组件自己跑自己的（Scriptable 就是这么干的），代价是不能在手机上改脚本 —— 改脚本 = 重新推一次代码等 CI
- **上付费账号**（$99/年）：拿到 App Groups，才能做「手机上编辑、组件实时更新」

阶段 1、2 免费账号完全够用。**所以先做 0→1→2，等真觉得「不能改脚本太难受」了，再花那 $99。**

---

## 已知风险（诚实列出来）

1. **免费 Apple ID 签带扩展的包** —— 这是阶段 0 要验证的核心。扩展和主 App 在同一个 bundle 里，SideStore 会逐个签内部的可执行文件，理论上没问题；但免费账号的 App ID 有限额（每周 10 个），一个 App + 一个扩展要占 2 个。**失败的话我们就知道了，早比晚好。**
2. **`xcode-27` 是 preview 镜像** —— 可能有排队或偶发不稳定。真不行就临时降级 `macos-26`，但要接受拿不到超大组件。
3. **7 天续签** —— 免费账号的证书 7 天过期。SideStore 会后台自动续，但**手机得偶尔开着、VPN 得能连上**。超过 7 天没续上，App 会打不开，重新用 SideStore 刷新一下即可（数据不会丢）。
4. **没有 App 图标** —— 阶段 0 没做，桌面上是个默认灰图标。后面补。
5. **我没法在本机编译 Swift** —— 每次改 Swift 都要走一遍 CI。所以我会尽量把改动攒成一次有意义的提交，而不是改一行推一次。

---

## 文件说明

| 文件 | 作用 |
|---|---|
| `project.yml` | XcodeGen 工程定义。靠它**不需要 Xcode 界面**就能生成 `.xcodeproj` |
| `Sources/App/` | 主 App（界面很轻，主要用来放说明） |
| `Sources/Widget/` | 组件扩展。**`supportedFamilies` 里那一行 `.systemExtraLarge` 就是全部重点** |
| `.github/workflows/build.yml` | CI：生成工程 → 编译 → 打 ipa → 发 Release |
