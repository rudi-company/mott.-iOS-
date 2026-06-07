import Foundation

struct Word: Identifiable, Hashable {
    let id: UUID
    let ingush: String
    let pronunciation: String
    let meanings: [BaseLanguage: String]
    let examples: [Phrase]
    let audioFileName: String?

    var meaning: String {
        meaning(in: .english)
    }

    init(
        id: UUID = UUID(),
        ingush: String,
        pronunciation: String,
        meaning: String,
        russianMeaning: String? = nil,
        examples: [Phrase] = [],
        audioFileName: String? = nil
    ) {
        var meanings: [BaseLanguage: String] = [.english: meaning]
        if let russianMeaning {
            meanings[.russian] = russianMeaning
        }

        self.id = id
        self.ingush = ingush
        self.pronunciation = pronunciation
        self.meanings = meanings
        self.examples = examples
        self.audioFileName = audioFileName
    }

    func meaning(in baseLanguage: BaseLanguage) -> String {
        meanings[baseLanguage] ?? meanings[.english] ?? ""
    }
}

struct Phrase: Identifiable, Hashable {
    let id: UUID
    let ingush: String
    let pronunciation: String
    let translations: [BaseLanguage: String]
    let audioFileName: String?

    var english: String {
        translation(in: .english)
    }

    init(
        id: UUID = UUID(),
        ingush: String,
        pronunciation: String,
        english: String,
        russian: String? = nil,
        audioFileName: String? = nil
    ) {
        var translations: [BaseLanguage: String] = [.english: english]
        if let russian {
            translations[.russian] = russian
        }

        self.id = id
        self.ingush = ingush
        self.pronunciation = pronunciation
        self.translations = translations
        self.audioFileName = audioFileName
    }

    func translation(in baseLanguage: BaseLanguage) -> String {
        translations[baseLanguage] ?? translations[.english] ?? ""
    }
}

struct Lesson: Identifiable, Hashable {
    let id: UUID
    let title: String
    let subtitle: String
    let progress: Double
    let isLocked: Bool
    let exercises: [Exercise]

    init(id: UUID = UUID(), title: String, subtitle: String, progress: Double, isLocked: Bool, exercises: [Exercise]) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.progress = progress
        self.isLocked = isLocked
        self.exercises = exercises
    }
}

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

    init(id: UUID = UUID(), kind: ExerciseKind, prompt: String, options: [ExerciseOption] = [], correctAnswer: String? = nil, audioFileName: String? = nil) {
        self.id = id
        self.kind = kind
        self.prompt = prompt
        self.options = options
        self.correctAnswer = correctAnswer
        self.audioFileName = audioFileName
    }
}

struct UserProgress: Hashable {
    let streakDays: Int
    let xp: Int
    let lessonsCompleted: Int
    let dailyGoalProgress: Double
    let dailyGoalText: String
}
