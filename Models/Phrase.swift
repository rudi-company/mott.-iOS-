import Foundation

struct Phrase: Identifiable, Hashable {
    let id: UUID
    let ingush: String
    let pronunciation: String
    let english: String
    let audioFileName: String?

    init(
        id: UUID = UUID(),
        ingush: String,
        pronunciation: String,
        english: String,
        audioFileName: String? = nil
    ) {
        self.id = id
        self.ingush = ingush
        self.pronunciation = pronunciation
        self.english = english
        self.audioFileName = audioFileName
    }
}
