import Foundation

enum ExerciseKind: String, Hashable {
    case multipleChoiceTranslation
    case wordMatching
    case listening
}

struct Exercise: Identifiable, Hashable {
    let id: UUID
    let kind: ExerciseKind
    let prompt: String
    let options: [ExerciseOption]
    let correctAnswer: String?
    let audioFileName: String?

    init(
        id: UUID = UUID(),
        kind: ExerciseKind,
        prompt: String,
        options: [ExerciseOption] = [],
        correctAnswer: String? = nil,
        audioFileName: String? = nil
    ) {
        self.id = id
        self.kind = kind
        self.prompt = prompt
        self.options = options
        self.correctAnswer = correctAnswer
        self.audioFileName = audioFileName
    }
}
