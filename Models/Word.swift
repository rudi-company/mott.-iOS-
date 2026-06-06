import Foundation

struct Word: Identifiable, Hashable {
    let id: UUID
    let ingush: String
    let pronunciation: String
    let meaning: String
    let examples: [Phrase]
    let audioFileName: String?

    init(
        id: UUID = UUID(),
        ingush: String,
        pronunciation: String,
        meaning: String,
        examples: [Phrase] = [],
        audioFileName: String? = nil
    ) {
        self.id = id
        self.ingush = ingush
        self.pronunciation = pronunciation
        self.meaning = meaning
        self.examples = examples
        self.audioFileName = audioFileName
    }
}
