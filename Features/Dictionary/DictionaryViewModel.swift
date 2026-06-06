import Foundation
import Observation

@MainActor
@Observable
final class DictionaryViewModel {
    var searchText = ""
    let words: [Word]

    var filteredWords: [Word] {
        let trimmedSearchText = searchText.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedSearchText.isEmpty else {
            return words
        }

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
