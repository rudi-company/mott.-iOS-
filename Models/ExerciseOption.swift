import Foundation

struct ExerciseOption: Identifiable, Hashable {
    let id: UUID
    let text: String
    let isCorrect: Bool

    init(id: UUID = UUID(), text: String, isCorrect: Bool) {
        self.id = id
        self.text = text
        self.isCorrect = isCorrect
    }
}
