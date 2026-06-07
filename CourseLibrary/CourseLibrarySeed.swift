import Foundation

/// Bundled draft content for the first Ingush course library.
enum CourseLibrarySeed {
    // TODO: Import real lexicon after a copyright-safe editorial workflow is defined.
    // TODO: Add native-speaker audio for words, phrases, examples, and pronunciation drills.
    // TODO: Add pronunciation minimal pairs for Ingush sounds.
    // TODO: Add case-ending drills and gender-agreement drills.
    // TODO: Add verb-conjugation drills for class and tense practice.
    // TODO: Add interlinear reading mode for longer texts.
    // TODO: Add copyright-safe content workflow before expanding source-derived lessons.
    // TODO: Add native-speaker validation status per grammar topic, lexeme, sentence, and exercise item.

    static let course = Course(
        id: "ingush_foundations",
        title: "Ingush Foundations",
        subtitle: "Learn Ingush from sounds to real sentences",
        baseLanguage: "English",
        targetLanguage: "Ingush",
        status: .draft,
        levels: makeLevels(),
        grammarTopics: grammarTopics,
        lexemes: lexemes,
        verbEntries: verbEntries,
        exampleSentences: exampleSentences,
        exercises: makeExercises()
    )

    static let sourceNote = "Used only as structural reference; do not copy source text."

    static let grammarTopics: [GrammarTopic] = [
        topic("sound_system", "Sound System", chapter: "2", section: "2.1"),
        topic("transcription_and_spelling", "Transcription and Spelling", chapter: "2", section: "2.2"),
        topic("vowels", "Vowels", chapter: "2", section: "2.3"),
        topic("consonants", "Consonants", chapter: "2", section: "2.4"),
        topic("schwa", "Schwa", chapter: "2", section: "2.5"),
        topic("stress", "Stress", chapter: "2", section: "2.6"),
        topic("word_classes", "Word Classes", chapter: "3", section: "3.1"),
        topic("noun_declension", "Noun Declension", chapter: "4", section: "4.1"),
        topic("noun_plurals", "Noun Plurals", chapter: "4", section: "4.2"),
        topic("agreement_gender", "Gender and Agreement", chapter: "5", section: "5.1"),
        topic("personal_pronouns", "Personal Pronouns", chapter: "6", section: "6.1"),
        topic("demonstratives", "Demonstratives", chapter: "6", section: "6.2"),
        topic("numerals", "Numerals", chapter: "7", section: "7.1"),
        topic("adjectives", "Adjectives", chapter: "8", section: "8.1"),
        topic("verb_conjugation_classes", "Verb Conjugation Classes", chapter: "9", section: "9.1"),
        topic("simple_tenses", "Simple Tenses", chapter: "10", section: "10.1"),
        topic("future_series", "Future Series", chapter: "10", section: "10.2"),
        topic("progressive_series", "Progressive Series", chapter: "10", section: "10.3"),
        topic("negation", "Negation", chapter: "11", section: "11.1"),
        topic("questions", "Questions", chapter: "12", section: "12.1"),
        topic("postpositions", "Postpositions", chapter: "13", section: "13.1"),
        topic("case_functions", "Case Functions", chapter: "14", section: "14.1"),
        topic("word_order", "Word Order", chapter: "15", section: "15.1"),
        topic("motion_verbs", "Motion Verbs", chapter: "16", section: "16.1"),
        topic("converbs_and_chaining", "Converbs and Chaining", chapter: "17", section: "17.1"),
        topic("relative_clauses", "Relative Clauses", chapter: "18", section: "18.1"),
        topic("discourse_markers", "Discourse Markers", chapter: "19", section: "19.1"),
        topic("texts_and_reading", "Texts and Reading", chapter: "20", section: "20.1")
    ]

    static let lexemes: [Lexeme] = [
        Lexeme(id: "lex_marsha", ingush: "Марша", transliteration: "marsha", englishGloss: "hello", partOfSpeech: "phrase", lessonIDs: ["a0_unit_01_lesson_01"], audioReference: placeholderAudio("marsha"), sourceReferences: [sourceReference(chapter: "2", section: "2.1")]),
        Lexeme(id: "lex_barkal", ingush: "Баркал", transliteration: "barkal", englishGloss: "thank you", partOfSpeech: "phrase", lessonIDs: ["a0_unit_03_lesson_01"], audioReference: placeholderAudio("barkal"), sourceReferences: [sourceReference(chapter: "3", section: "3.1")]),
        Lexeme(id: "lex_so", ingush: "Со", transliteration: "so", englishGloss: "I", partOfSpeech: "pronoun", lessonIDs: ["a0_unit_04_lesson_01", "a1_unit_06_lesson_01"], audioReference: placeholderAudio("so"), sourceReferences: [sourceReference(chapter: "6", section: "6.1")]),
        Lexeme(id: "lex_hwo", ingush: "Хьо", transliteration: "hwo", englishGloss: "you", partOfSpeech: "pronoun", lessonIDs: ["a0_unit_04_lesson_01", "a1_unit_06_lesson_01"], audioReference: placeholderAudio("hwo"), sourceReferences: [sourceReference(chapter: "6", section: "6.1")]),
        Lexeme(id: "lex_tskha", ingush: "Цхьа", transliteration: "tskha", englishGloss: "one", partOfSpeech: "numeral", lessonIDs: ["a0_unit_05_lesson_01"], audioReference: placeholderAudio("tskha"), sourceReferences: [sourceReference(chapter: "7", section: "7.1")]),
        Lexeme(id: "lex_shi", ingush: "Ши", transliteration: "shi", englishGloss: "two", partOfSpeech: "numeral", lessonIDs: ["a0_unit_05_lesson_01"], audioReference: placeholderAudio("shi"), sourceReferences: [sourceReference(chapter: "7", section: "7.1")])
    ]

    static let verbEntries: [VerbEntry] = [
        VerbEntry(id: "verb_placeholder_go", citationForm: "—", transliteration: "placeholder", englishGloss: "go", classID: nil, lessonIDs: ["a2_unit_11_lesson_01"], sourceReferences: [sourceReference(chapter: "9", section: "9.1")]),
        VerbEntry(id: "verb_placeholder_say", citationForm: "—", transliteration: "placeholder", englishGloss: "say", classID: nil, lessonIDs: ["a2_unit_11_lesson_02"], sourceReferences: [sourceReference(chapter: "9", section: "9.1")])
    ]

    static let exampleSentences: [ExampleSentence] = [
        ExampleSentence(id: "example_a0_greeting", ingush: "Марша.", transliteration: "marsha", english: "Hello.", lessonIDs: ["a0_unit_01_lesson_01"], audioReference: placeholderAudio("example_a0_greeting"), sourceReferences: [sourceReference(chapter: "2", section: "2.1")]),
        ExampleSentence(id: "example_a0_pronoun", ingush: "Со ...", transliteration: "so ...", english: "I ...", lessonIDs: ["a0_unit_04_lesson_01"], audioReference: nil, sourceReferences: [sourceReference(chapter: "6", section: "6.1")])
    ]

    static func sourceReference(chapter: String? = nil, section: String? = nil, page: Int? = nil) -> SourceReference {
        SourceReference(
            sourceTitle: "Ingush Grammar",
            author: "Johanna Nichols",
            chapter: chapter,
            section: section,
            page: page,
            note: sourceNote
        )
    }

    private static func makeLevels() -> [CourseLevel] {
        [
            makeLevel(id: "A0", title: "Survival Ingush", unitTitles: ["What is Ingush?", "Sounds and Spelling", "First Words", "First Sentences", "Numbers and Time"], startingUnit: 1),
            makeLevel(id: "A1", title: "Basic Grammar and Daily Sentences", unitTitles: ["Nouns", "Cases I", "Cases II", "Gender and Agreement", "Adjectives"], startingUnit: 6),
            makeLevel(id: "A2", title: "Verbs and Sentence Control", unitTitles: ["Verb Basics", "Verb Classes", "Tense and Aspect I", "Negation", "Questions"], startingUnit: 11),
            makeLevel(id: "B1", title: "Real Ingush Structure", unitTitles: ["Word Order", "Motion and Direction", "Chaining and Converbs", "Relative Clauses and Subordination", "Discourse and Texts"], startingUnit: 16),
        ]
    }

    private static func makeLevel(id: String, title: String, unitTitles: [String], startingUnit: Int) -> CourseLevel {
        let units = unitTitles.enumerated().map { offset, title in
            makeUnit(levelID: id, sequence: startingUnit + offset, title: title)
        }
        return CourseLevel(id: id, title: title, subtitle: "Draft pathway", units: units)
    }

    private static func makeUnit(levelID: String, sequence: Int, title: String) -> CourseUnit {
        let unitID = "\(levelID.lowercased())_unit_\(twoDigitString(for: sequence))"
        let topicIDs = topicIDsForUnit(sequence)
        let lessons = (1...3).map { lessonNumber in
            makeLesson(levelID: levelID, unitID: unitID, unitSequence: sequence, unitTitle: title, lessonNumber: lessonNumber, topicIDs: topicIDs)
        }

        return CourseUnit(
            id: unitID,
            levelID: levelID,
            sequence: sequence,
            title: title,
            summary: "A draft unit that introduces \(title.lowercased()) through short explanations and practice.",
            lessons: lessons
        )
    }

    private static func makeLesson(levelID: String, unitID: String, unitSequence: Int, unitTitle: String, lessonNumber: Int, topicIDs: [String]) -> CourseLesson {
        let lessonID = "\(unitID)_lesson_\(twoDigitString(for: lessonNumber))"
        let primaryTopicID = topicIDs[(lessonNumber - 1) % topicIDs.count]

        return CourseLesson(
            id: lessonID,
            title: lessonTitle(for: unitTitle, lessonNumber: lessonNumber),
            levelID: levelID,
            unitID: unitID,
            estimatedMinutes: lessonNumber == 1 ? 6 : 8,
            description: "A short original lesson placeholder for \(unitTitle.lowercased()) that will be expanded after linguistic and native-speaker review.",
            blocks: [
                LessonBlock(id: "\(lessonID)_concept", kind: .concept, title: "Core idea", body: "Introduce one learner-facing idea with original wording."),
                LessonBlock(id: "\(lessonID)_pattern", kind: .pattern, title: "Pattern", body: "Show the reusable sentence or word pattern without copying source prose."),
                LessonBlock(id: "\(lessonID)_practice", kind: .practicePrompt, title: "Practice", body: "Prepare a short interaction that checks recognition before production.")
            ],
            grammarTopicIDs: [primaryTopicID],
            lexemeIDs: lexemeIDsForLesson(lessonID),
            exerciseIDs: ["exercise_\(lessonID)"],
            sourceReferences: [sourceReference(chapter: chapterForUnit(unitSequence), section: sectionForUnit(unitSequence))],
            audioReference: nil
        )
    }

    private static func makeExercises() -> [CourseLibrary.Exercise] {
        courseLessons.map { lesson in
            CourseLibrary.Exercise(
                id: "exercise_\(lesson.id)",
                lessonID: lesson.id,
                kind: exerciseKind(for: lesson),
                title: "Practice: \(lesson.title)",
                items: [
                    CourseLibrary.ExerciseItem(
                        id: "exercise_\(lesson.id)_item_01",
                        prompt: "Choose the best placeholder answer for this lesson concept.",
                        choices: ["Option A", "Option B", "Option C"],
                        correctAnswer: "Option A",
                        explanation: "Replace with an original explanation after review."
                    )
                ],
                sourceReferences: lesson.sourceReferences,
                audioReference: nil
            )
        }
    }

    private static var courseLessons: [CourseLesson] {
        makeLevels().flatMap(\.units).flatMap(\.lessons)
    }

    private static func topic(_ id: String, _ title: String, chapter: String, section: String) -> GrammarTopic {
        GrammarTopic(
            id: id,
            title: title,
            summary: "Draft topic placeholder for app-authored instruction and practice.",
            sourceReferences: [sourceReference(chapter: chapter, section: section)]
        )
    }

    private static func placeholderAudio(_ id: String) -> AudioAssetReference {
        AudioAssetReference(id: "audio_\(id)", fileName: nil, speakerID: nil, validationStatus: .placeholder)
    }

    private static func lessonTitle(for unitTitle: String, lessonNumber: Int) -> String {
        switch lessonNumber {
        case 1: "Start with \(unitTitle)"
        case 2: "Recognize \(unitTitle)"
        default: "Use \(unitTitle)"
        }
    }

    private static func lexemeIDsForLesson(_ lessonID: String) -> [String] {
        lexemes.filter { $0.lessonIDs.contains(lessonID) }.map(\.id)
    }

    private static func exerciseKind(for lesson: CourseLesson) -> CourseLibrary.ExerciseKind {
        if lesson.id.contains("sounds") || lesson.grammarTopicIDs.contains("vowels") || lesson.grammarTopicIDs.contains("consonants") {
            return .listening
        }

        if lesson.grammarTopicIDs.contains("noun_declension") || lesson.grammarTopicIDs.contains("case_functions") {
            return .caseEndingDrill
        }

        if lesson.grammarTopicIDs.contains("agreement_gender") {
            return .genderAgreementDrill
        }

        if lesson.grammarTopicIDs.contains("verb_conjugation_classes") || lesson.grammarTopicIDs.contains("simple_tenses") {
            return .verbConjugationDrill
        }

        return .multipleChoice
    }

    private static func twoDigitString(for value: Int) -> String {
        value < 10 ? "0\(value)" : "\(value)"
    }

    private static func topicIDsForUnit(_ sequence: Int) -> [String] {
        switch sequence {
        case 1: ["word_classes", "texts_and_reading", "discourse_markers"]
        case 2: ["sound_system", "transcription_and_spelling", "vowels", "consonants", "schwa", "stress"]
        case 3: ["word_classes", "personal_pronouns", "demonstratives"]
        case 4: ["personal_pronouns", "word_order", "questions"]
        case 5: ["numerals", "simple_tenses", "questions"]
        case 6: ["noun_declension", "noun_plurals", "word_classes"]
        case 7: ["case_functions", "noun_declension", "postpositions"]
        case 8: ["case_functions", "postpositions", "word_order"]
        case 9: ["agreement_gender", "word_classes", "adjectives"]
        case 10: ["adjectives", "agreement_gender", "word_order"]
        case 11: ["verb_conjugation_classes", "simple_tenses", "word_order"]
        case 12: ["verb_conjugation_classes", "progressive_series", "future_series"]
        case 13: ["simple_tenses", "future_series", "progressive_series"]
        case 14: ["negation", "simple_tenses", "questions"]
        case 15: ["questions", "word_order", "demonstratives"]
        case 16: ["word_order", "case_functions", "postpositions"]
        case 17: ["motion_verbs", "case_functions", "word_order"]
        case 18: ["converbs_and_chaining", "simple_tenses", "discourse_markers"]
        case 19: ["relative_clauses", "converbs_and_chaining", "word_order"]
        default: ["discourse_markers", "texts_and_reading", "relative_clauses"]
        }
    }

    private static func chapterForUnit(_ sequence: Int) -> String {
        String(max(2, sequence + 1))
    }

    private static func sectionForUnit(_ sequence: Int) -> String {
        "\(max(2, sequence + 1)).1"
    }
}
