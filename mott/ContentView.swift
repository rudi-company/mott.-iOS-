import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            Tab("Learn", systemImage: "graduationcap") {
                LearnView()
            }

            Tab("Practice", systemImage: "figure.walk.motion") {
                PracticeView()
            }

            Tab("Dictionary", systemImage: "character.book.closed") {
                DictionaryView()
            }

            Tab("Profile", systemImage: "person.crop.circle") {
                ProfileView()
            }
        }
    }
}

#Preview {
    ContentView()
        .environment(AudioManager())
}
