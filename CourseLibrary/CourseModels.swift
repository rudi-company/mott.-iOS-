import Foundation

/// A bundled language course that can later be migrated to SwiftData or SQLite.
struct Course: Identifiable, Codable, Hashable {
    let id: String
    let title: String
    let subtitle: String
    let baseLanguage: String
    let targetLanguage: String
    let status: CourseStatus
    let levels: [CourseLevel]
    let grammarTopics: [GrammarTopic]
    let lexemes: [Lexeme]
    let verbEntries: [VerbEntry]
    let exampleSentences: [ExampleSentence]
    let exercises: [CourseLibrary.Exercise]
}

/// The editorial state of a bundled course.
enum CourseStatus: String, Codable, Hashable {
    case draft
    case review
    case published
}

/// A unit within a level of a course.
struct CourseUnit: Identifiable, Codable, Hashable {
    let id: String
    let levelID: String
    let sequence: Int
    let title: String
    let summary: String
    let lessons: [CourseLesson]
}

/// A single teachable lesson in the course path.
struct CourseLesson: Identifiable, Codable, Hashable {
    let id: String
    let title: String
    let levelID: String
    let unitID: String
    let estimatedMinutes: Int
    let description: String
    let blocks: [LessonBlock]
    let grammarTopicIDs: [String]
    let lexemeIDs: [String]
    let exerciseIDs: [String]
    let sourceReferences: [SourceReference]
    let audioReference: AudioAssetReference?
}

/// A block of original app-authored teaching content inside a lesson.
struct LessonBlock: Identifiable, Codable, Hashable {
    let id: String
    let kind: LessonBlockKind
    let title: String
    let body: String
}

/// The role a teaching block plays inside a lesson.
enum LessonBlockKind: String, Codable, Hashable {
    case concept
    case pattern
    case example
    case practicePrompt
}

/// A grammar concept that can be reused across lessons.
struct GrammarTopic: Identifiable, Codable, Hashable {
    let id: String
    let title: String
    let summary: String
    let sourceReferences: [SourceReference]
}

/// A vocabulary item used by course lessons.
struct Lexeme: Identifiable, Codable, Hashable {
    let id: String
    let ingush: String
    let transliteration: String
    let englishGloss: String
    let partOfSpeech: String
    let lessonIDs: [String]
    let audioReference: AudioAssetReference?
    let sourceReferences: [SourceReference]
}

/// A verb entry prepared for future conjugation-focused lessons.
struct VerbEntry: Identifiable, Codable, Hashable {
    let id: String
    let citationForm: String
    let transliteration: String
    let englishGloss: String
    let classID: String?
    let lessonIDs: [String]
    let sourceReferences: [SourceReference]
}

/// An original example sentence that can be attached to lessons, lexemes, or exercises.
struct ExampleSentence: Identifiable, Codable, Hashable {
    let id: String
    let ingush: String
    let transliteration: String
    let english: String
    let lessonIDs: [String]
    let audioReference: AudioAssetReference?
    let sourceReferences: [SourceReference]
}

/// A reference to a future bundled or remote audio asset.
struct AudioAssetReference: Identifiable, Codable, Hashable {
    let id: String
    let fileName: String?
    let speakerID: String?
    let validationStatus: AudioValidationStatus
}

/// Review state for future native-speaker audio assets.
enum AudioValidationStatus: String, Codable, Hashable {
    case placeholder
    case needsNativeSpeakerReview
    case approved
}

/// A source pointer that tracks structure without storing copied book text.
struct SourceReference: Identifiable, Codable, Hashable {
    var id: String { [sourceTitle, author, chapter, section, page.map(String.init) ?? "no-page"].joined(separator: "|") }

    let sourceTitle: String
    let author: String
    let chapter: String?
    let section: String?
    let page: Int?
    let note: String
}

/// Namespace for course-library types that would otherwise conflict with the app lesson flow.
enum CourseLibrary {}

extension CourseLibrary {
    /// A course-library exercise linked to a lesson.
    struct Exercise: Identifiable, Codable, Hashable {
        let id: String
        let lessonID: String
        let kind: ExerciseKind
        let title: String
        let items: [ExerciseItem]
        let sourceReferences: [SourceReference]
        let audioReference: AudioAssetReference?
    }

    /// A prompt inside a course-library exercise.
    struct ExerciseItem: Identifiable, Codable, Hashable {
        let id: String
        let prompt: String
        let choices: [String]
        let correctAnswer: String
        let explanation: String?
    }

    /// The exercise interaction planned for the app.
    enum ExerciseKind: String, Codable, Hashable {
        case multipleChoice
        case listening
        case matching
        case pronunciation
        case caseEndingDrill
        case genderAgreementDrill
        case verbConjugationDrill
        case reading
    }
}
