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
                || word.meaning.localizedStandardContains(trimmedSearchText)
        }
    }

    init(words: [Word] = MockCourseData.dictionaryWords) {
        self.words = words
    }
}

struct DictionaryView: View {
    @State private var viewModel = DictionaryViewModel()

    var body: some View {
        NavigationStack {
            List(viewModel.filteredWords) { word in
                NavigationLink(value: word) {
                    DictionaryWordRow(word: word)
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Dictionary")
            .searchable(text: $viewModel.searchText, prompt: "Search Ingush or English")
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

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(alignment: .firstTextBaseline) {
                Text(word.ingush).font(.headline)
                Text(word.pronunciation).font(.subheadline).foregroundStyle(.secondary)
            }
            Text(word.meaning).font(.subheadline).foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
    }
}

struct WordDetailView: View {
    @Environment(AudioManager.self) private var audioManager
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
                    Text(word.meaning)
                        .font(.headline)
                }
                .padding(.vertical, 8)

                Button("Play Audio", systemImage: "speaker.wave.2.fill") {
                    audioManager.playPlaceholder(audioFileName: word.audioFileName)
                }
            }

            Section("Examples") {
                ForEach(word.examples) { phrase in
                    PhraseExampleRow(phrase: phrase)
                }
            }
        }
        .navigationTitle(word.meaning.capitalized)
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct PhraseExampleRow: View {
    let phrase: Phrase

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(phrase.ingush).font(.headline)
            Text(phrase.pronunciation).font(.subheadline).foregroundStyle(.secondary)
            Text(phrase.english).font(.subheadline).foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
    }
}
