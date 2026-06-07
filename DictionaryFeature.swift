import SwiftUI
import Observation

@MainActor
@Observable
final class DictionaryViewModel {
    var searchText = ""
    let words: [Word]

    var filteredWords: [Word] {
        let trimmedSearchText = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedSearchText.isEmpty else { return words }

        return words.filter { word in
            word.ingush.localizedStandardContains(trimmedSearchText)
                || word.pronunciation.localizedStandardContains(trimmedSearchText)
                || word.meanings.values.contains { $0.localizedStandardContains(trimmedSearchText) }
        }
    }

    init() {
        self.words = MockCourseData.dictionaryWords
    }

    init(words: [Word]) {
        self.words = words
    }
}

struct DictionaryView: View {
    @Environment(AppSettings.self) private var appSettings
    @State private var viewModel = DictionaryViewModel()

    var body: some View {
        NavigationStack {
            List(viewModel.filteredWords) { word in
                NavigationLink(value: word) {
                    DictionaryWordRow(word: word, baseLanguage: appSettings.baseLanguage)
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Dictionary")
            .settingsToolbar()
            .searchable(text: $viewModel.searchText, prompt: "Search Ingush or translation")
            .navigationDestination(for: Word.self) { word in
                WordDetailView(word: word)
            }
            .overlay {
                if viewModel.filteredWords.isEmpty {
                    ContentUnavailableView.search(text: viewModel.searchText)
                }
            }
        }
    }
}

private struct DictionaryWordRow: View {
    let word: Word
    let baseLanguage: BaseLanguage

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(alignment: .firstTextBaseline) {
                Text(word.ingush).font(.headline)
                Text(word.pronunciation).font(.subheadline).foregroundStyle(.secondary)
            }
            Text(word.meaning(in: baseLanguage)).font(.subheadline).foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
    }
}

struct WordDetailView: View {
    @Environment(AudioManager.self) private var audioManager
    @Environment(AppSettings.self) private var appSettings
    let word: Word

    var body: some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: 12) {
                    Text(word.ingush)
                        .font(.largeTitle)
                        .bold()
                    Text(word.pronunciation)
                        .font(.title3)
                        .foregroundStyle(.secondary)
                    Text(word.meaning(in: appSettings.baseLanguage))
                        .font(.headline)
                }
                .padding(.vertical, 8)

                Button("Play Audio", systemImage: "speaker.wave.2.fill") {
                    audioManager.playPlaceholder(audioFileName: word.audioFileName)
                }
            }

            Section("Examples") {
                ForEach(word.examples) { phrase in
                    PhraseExampleRow(phrase: phrase, baseLanguage: appSettings.baseLanguage)
                }
            }
        }
        .navigationTitle(word.meaning(in: appSettings.baseLanguage).capitalized)
        .navigationBarTitleDisplayMode(.inline)
        .settingsToolbar()
    }
}

private struct PhraseExampleRow: View {
    let phrase: Phrase
    let baseLanguage: BaseLanguage

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(phrase.ingush).font(.headline)
            Text(phrase.pronunciation).font(.subheadline).foregroundStyle(.secondary)
            Text(phrase.translation(in: baseLanguage)).font(.subheadline).foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
    }
}
