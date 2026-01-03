# Repository Guidelines

## Project Structure & Module Organization
- App shell: `ThreeDisplay/` (entry point, entitlements, app assets).
- Feature code: `ThreeDisplayPackage/Sources/ThreeDisplayFeature/` (SwiftUI + SceneKit/Metal work lives here).
- Unit tests: `ThreeDisplayPackage/Tests/ThreeDisplayFeatureTests/` (Swift Testing).
- UI tests: `ThreeDisplayUITests/` (XCUITest).
- Workspace/project: `ThreeDisplay.xcworkspace` (open this in Xcode), `ThreeDisplay.xcodeproj`.
- Configuration: `Config/*.xcconfig` (bundle ID, build settings).

## Build, Test, and Development Commands
- Open in Xcode: `open ThreeDisplay.xcworkspace`
- Build (CLI): `xcodebuild -workspace ThreeDisplay.xcworkspace -scheme ThreeDisplay build`
- Test (CLI): `xcodebuild -workspace ThreeDisplay.xcworkspace -scheme ThreeDisplay test`
- Package tests only: `cd ThreeDisplayPackage && swift test`

## Coding Style & Naming Conventions
- Swift API Design Guidelines; prefer `UpperCamelCase` for types and `lowerCamelCase` for vars/functions.
- Indentation: 4 spaces; keep lines readable and avoid long chained expressions.
- File names match primary type (e.g., `SceneKitOverlayView.swift`).

## Testing Guidelines
- Use Swift Testing for unit tests; name test files `*Tests.swift` and functions with descriptive sentences.
- UI tests live in `ThreeDisplayUITests/` and should focus on user-visible behavior.
- For UI changes, verify on at least one physical display and one external monitor if available.

## Commit & Pull Request Guidelines
- Commit messages are short, imperative, and descriptive (e.g., "Add overlay window and SceneKit view").
- PRs should include: summary, steps to run, and screenshots/video for visual changes (overlay/3D).
- Link any tracking issue if available.

## Security & Configuration Tips
- Camera usage will require Info.plist usage strings and entitlements; keep privacy prompts clear.
- Overlay window behavior is sensitive; document any changes that affect system-wide UI.

## 日本語版

### プロジェクト構成
- アプリ本体: `ThreeDisplay/`（エントリーポイント、entitlements、アセット）。
- 機能実装: `ThreeDisplayPackage/Sources/ThreeDisplayFeature/`（SwiftUI + SceneKit/Metal）。
- 単体テスト: `ThreeDisplayPackage/Tests/ThreeDisplayFeatureTests/`（Swift Testing）。
- UIテスト: `ThreeDisplayUITests/`（XCUITest）。

### ビルド/テスト
- Xcodeを開く: `open ThreeDisplay.xcworkspace`
- CLIビルド: `xcodebuild -workspace ThreeDisplay.xcworkspace -scheme ThreeDisplay build`
- CLIテスト: `xcodebuild -workspace ThreeDisplay.xcworkspace -scheme ThreeDisplay test`
- パッケージ単体テスト: `cd ThreeDisplayPackage && swift test`

### コーディング/命名
- Swift API Design Guidelinesに準拠（型は`UpperCamelCase`、変数/関数は`lowerCamelCase`）。
- インデントは4スペース。
- ファイル名は主要型に合わせる（例: `SceneKitOverlayView.swift`）。

### テスト指針
- 単体テストは`*Tests.swift`、分かりやすいテスト名を付ける。
- UI変更は可能なら内蔵ディスプレイと外部ディスプレイで確認。

### コミット/PR
- コミットは短く命令形（例: \"Add overlay window and SceneKit view\"）。
- PRには概要、再現手順、画面/動画（視覚変更時）を含める。

### セキュリティ/設定
- カメラ利用はInfo.plistの用途説明とentitlementsが必要。
- オーバーレイ挙動の変更は影響範囲を明記。
