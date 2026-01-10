# ThreeDisplay - macOS App

## Project Goal

macOS上で「ディスプレイから飛び出す」3D表現をリアルタイムに実現するPoC。
内蔵カメラは視点推定（飛び出し方向制御）に使い、SceneKit/Metalで演出を強化する。

See `docs/ROADMAP.md` and `docs/IDEAS.md` for the initial direction.
See `docs/USAGE.md` for launch steps and controls.

A modern macOS application using a **workspace + SPM package** architecture for clean separation between app shell and feature code.

## Project Architecture

```
ThreeDisplay/
├── ThreeDisplay.xcworkspace/              # Open this file in Xcode
├── ThreeDisplay.xcodeproj/                # App shell project
├── ThreeDisplay/                          # App target (minimal)
│   ├── Assets.xcassets/                # App-level assets (icons, colors)
│   ├── ThreeDisplayApp.swift              # App entry point
│   ├── ThreeDisplay.entitlements          # App sandbox settings
│   └── ThreeDisplay.xctestplan            # Test configuration
├── ThreeDisplayPackage/                   # 🚀 Primary development area
│   ├── Package.swift                   # Package configuration
│   ├── Sources/ThreeDisplayFeature/       # Your feature code
│   └── Tests/ThreeDisplayFeatureTests/    # Unit tests
└── ThreeDisplayUITests/                   # UI automation tests
```

## Key Architecture Points

### Workspace + SPM Structure
- **App Shell**: `ThreeDisplay/` contains minimal app lifecycle code
- **Feature Code**: `ThreeDisplayPackage/Sources/ThreeDisplayFeature/` is where most development happens
- **Separation**: Business logic lives in the SPM package, app target just imports and displays it

### Buildable Folders (Xcode 16)
- Files added to the filesystem automatically appear in Xcode
- No need to manually add files to project targets
- Reduces project file conflicts in teams

### App Sandbox
The app is sandboxed by default with basic file access permissions. Modify `ThreeDisplay.entitlements` to add capabilities as needed.

## Development Notes

### Code Organization
Most development happens in `ThreeDisplayPackage/Sources/ThreeDisplayFeature/` - organize your code as you prefer.

### Public API Requirements
Types exposed to the app target need `public` access:
```swift
public struct SettingsView: View {
    public init() {}
    
    public var body: some View {
        // Your view code
    }
}
```

### Adding Dependencies
Edit `ThreeDisplayPackage/Package.swift` to add SPM dependencies:
```swift
dependencies: [
    .package(url: "https://github.com/example/SomePackage", from: "1.0.0")
],
targets: [
    .target(
        name: "ThreeDisplayFeature",
        dependencies: ["SomePackage"]
    ),
]
```

### Test Structure
- **Unit Tests**: `ThreeDisplayPackage/Tests/ThreeDisplayFeatureTests/` (Swift Testing framework)
- **UI Tests**: `ThreeDisplayUITests/` (XCUITest framework)
- **Test Plan**: `ThreeDisplay.xctestplan` coordinates all tests

## Configuration

### XCConfig Build Settings
Build settings are managed through **XCConfig files** in `Config/`:
- `Config/Shared.xcconfig` - Common settings (bundle ID, versions, deployment target)
- `Config/Debug.xcconfig` - Debug-specific settings  
- `Config/Release.xcconfig` - Release-specific settings
- `Config/Tests.xcconfig` - Test-specific settings

### App Sandbox & Entitlements
The app is sandboxed by default with basic file access. Edit `ThreeDisplay/ThreeDisplay.entitlements` to add capabilities:
```xml
<key>com.apple.security.files.user-selected.read-write</key>
<true/>
<key>com.apple.security.network.client</key>
<true/>
<!-- Add other entitlements as needed -->
```

## macOS-Specific Features

### Window Management
Add multiple windows and settings panels:
```swift
@main
struct ThreeDisplayApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        
        Settings {
            SettingsView()
        }
    }
}
```

### Asset Management
- **App-Level Assets**: `ThreeDisplay/Assets.xcassets/` (app icon with multiple sizes, accent color)
- **Feature Assets**: Add `Resources/` folder to SPM package if needed

### SPM Package Resources
To include assets in your feature package:
```swift
.target(
    name: "ThreeDisplayFeature",
    dependencies: [],
    resources: [.process("Resources")]
)
```

## Notes

### Generated with XcodeBuildMCP
This project was scaffolded using [XcodeBuildMCP](https://github.com/cameroncooke/XcodeBuildMCP), which provides tools for AI-assisted macOS development workflows.
