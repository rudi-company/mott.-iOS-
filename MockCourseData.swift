import Foundation

enum MockCourseData {
    // TODO: Future real native-speaker recordings will be attached to words and phrases.
    // TODO: Future AI-generated Ingush audio may be tested, but all generated audio must be reviewed by a native speaker before release.
    static let userProgress = UserProgress(
        streakDays: 4,
        xp: 1280,
        lessonsCompleted: 3,
        dailyGoalProgress: 0.6,
        dailyGoalText: "3 of 5 exercises"
    )

    static let dictionaryWords: [Word] = [
        Word(ingush: "Марша", pronunciation: "marsha", meaning: "hello", russianMeaning: "здравствуйте", examples: [
            Phrase(ingush: "Марша, хьо мишта ва?", pronunciation: "marsha, h'o mishta va?", english: "Hello, how are you?", russian: "Здравствуйте, как вы?")
        ], audioFileName: "marsha"),
        Word(ingush: "Баркал", pronunciation: "barkal", meaning: "thank you", russianMeaning: "спасибо", examples: [
            Phrase(ingush: "Баркал хьуна.", pronunciation: "barkal h'una", english: "Thank you.", russian: "Спасибо.")
        ], audioFileName: "barkal"),
        Word(ingush: "Да", pronunciation: "da", meaning: "father", russianMeaning: "отец", examples: [
            Phrase(ingush: "Со дацара къамаьл ду.", pronunciation: "so datsara qamael du", english: "I am speaking with father.", russian: "Я говорю с отцом.")
        ], audioFileName: "da"),
        Word(ingush: "Нана", pronunciation: "nana", meaning: "mother", russianMeaning: "мать", examples: [
            Phrase(ingush: "Нана цIагIа я.", pronunciation: "nana ts'ag'a ya", english: "Mother is at home.", russian: "Мать дома.")
        ], audioFileName: "nana"),
        Word(ingush: "Цхьа", pronunciation: "tskha", meaning: "one", russianMeaning: "один", examples: [
            Phrase(ingush: "Цхьа книжка.", pronunciation: "tskha knizhka", english: "One book.", russian: "Одна книга.")
        ], audioFileName: "tskha"),
        Word(ingush: "Ши", pronunciation: "shi", meaning: "two", russianMeaning: "два", examples: [
            Phrase(ingush: "Ши дош.", pronunciation: "shi dosh", english: "Two words.", russian: "Два слова.")
        ], audioFileName: "shi")
    ]

    static let lessons: [Lesson] = [
        Lesson(title: "Greetings", subtitle: "Say hello and answer simply", progress: 0.6, isLocked: false, exercises: greetingExercises),
        Lesson(title: "Basic Pronouns", subtitle: "I, you, we, and they", progress: 0.2, isLocked: false, exercises: pronounExercises),
        Lesson(title: "Family", subtitle: "Talk about close relatives", progress: 0, isLocked: false, exercises: familyExercises),
        Lesson(title: "Numbers", subtitle: "Count from one to ten", progress: 0, isLocked: true, exercises: numberExercises),
        Lesson(title: "Common Phrases", subtitle: "Useful phrases for daily speech", progress: 0, isLocked: true, exercises: phraseExercises)
    ]

    static let weakWords: [Word] = Array(dictionaryWords.prefix(3))

    private static let greetingExercises: [Exercise] = [
        Exercise(kind: .multipleChoiceTranslation, prompt: "What does “Марша” mean?", options: [
            ExerciseOption(text: "Hello", isCorrect: true),
            ExerciseOption(text: "Good night", isCorrect: false),
            ExerciseOption(text: "Please", isCorrect: false)
        ], correctAnswer: "Hello", audioFileName: "marsha"),
        Exercise(kind: .wordMatching, prompt: "Match each greeting with its meaning.", correctAnswer: "Марша - Hello"),
        Exercise(kind: .listening, prompt: "Listen and choose the phrase you hear.", options: [
            ExerciseOption(text: "Марша", isCorrect: true),
            ExerciseOption(text: "Баркал", isCorrect: false),
            ExerciseOption(text: "Нана", isCorrect: false)
        ], correctAnswer: "Марша", audioFileName: "marsha")
    ]

    private static let pronounExercises: [Exercise] = [
        Exercise(kind: .multipleChoiceTranslation, prompt: "Choose the Ingush word for “I”.", options: [
            ExerciseOption(text: "Со", isCorrect: true),
            ExerciseOption(text: "Хьо", isCorrect: false),
            ExerciseOption(text: "Тхо", isCorrect: false)
        ], correctAnswer: "Со"),
        Exercise(kind: .wordMatching, prompt: "Pair each pronoun with its English meaning.", correctAnswer: "Со - I")
    ]

    private static let familyExercises: [Exercise] = [
        Exercise(kind: .multipleChoiceTranslation, prompt: "What does “Нана” mean?", options: [
            ExerciseOption(text: "Mother", isCorrect: true),
            ExerciseOption(text: "Father", isCorrect: false),
            ExerciseOption(text: "Sister", isCorrect: false)
        ], correctAnswer: "Mother", audioFileName: "nana"),
        Exercise(kind: .listening, prompt: "Listening practice for family words.", correctAnswer: "Нана", audioFileName: "nana")
    ]

    private static let numberExercises: [Exercise] = [
        Exercise(kind: .multipleChoiceTranslation, prompt: "What does “Цхьа” mean?", options: [
            ExerciseOption(text: "One", isCorrect: true),
            ExerciseOption(text: "Two", isCorrect: false),
            ExerciseOption(text: "Three", isCorrect: false)
        ], correctAnswer: "One")
    ]

    private static let phraseExercises: [Exercise] = [
        Exercise(kind: .multipleChoiceTranslation, prompt: "What does “Баркал” mean?", options: [
            ExerciseOption(text: "Thank you", isCorrect: true),
            ExerciseOption(text: "Goodbye", isCorrect: false),
            ExerciseOption(text: "Welcome", isCorrect: false)
        ], correctAnswer: "Thank you", audioFileName: "barkal")
    ]
}
