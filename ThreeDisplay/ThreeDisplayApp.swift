import SwiftUI
import ThreeDisplayFeature

@main
struct ThreeDisplayApp: App {
    @StateObject private var overlaySettings = OverlaySettings()

    var body: some Scene {
        WindowGroup {
            ContentView(settings: overlaySettings)
        }
        .commands {
            CommandMenu("Overlay") {
                Toggle("Enable Interaction", isOn: $overlaySettings.allowsInteraction)
                    .keyboardShortcut("i", modifiers: [.command, .option])
            }
        }
    }
}
