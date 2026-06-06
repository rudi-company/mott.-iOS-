import SwiftUI

@main
struct MottApp: App {
    @State private var audioManager = AudioManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(audioManager)
        }
    }
}
