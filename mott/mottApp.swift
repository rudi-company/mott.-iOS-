import SwiftUI

@main
struct MottApp: App {
    @State private var audioManager = AudioManager()
    @State private var appSettings = AppSettings()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(audioManager)
                .environment(appSettings)
        }
    }
}
