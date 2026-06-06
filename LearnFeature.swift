import SwiftUI
import Observation

@MainActor
@Observable
final class LearnViewModel {
    let lessons: [Lesson]
    let progress: UserProgress

    init(lessons: [Lesson] = MockCourseData.lessons, progress: UserProgress = MockCourseData.userProgress) {
        self.lessons = lessons
        self.progress = progress
    }
}

enum ExerciseFeedback: Equatable {
    case correct
    case incorrect
    case needsSelection
}

@MainActor
@Observable
final class LessonFlowViewModel {
    let lesson: Lesson
    private(set) var currentIndex = 0
    var selectedOption: ExerciseOption?
    var feedback: ExerciseFeedback?

    var currentExercise: Exercise { lesson.exercises[currentIndex] }
    var progress: Double { lesson.exercises.isEmpty ? 0 : Double(currentIndex + 1) / Double(lesson.exercises.count) }
    var isLastExercise: Bool { currentIndex == lesson.exercises.count - 1 }

    init(lesson: Lesson) {
        self.lesson = lesson
    }

    func select(_ option: ExerciseOption) {
        selectedOption = option
        feedback = nil
    }

    func checkAnswer() {
        if currentExercise.options.isEmpty {
            feedback = .correct
            return
        }

        guard let selectedOption else {
            feedback = .needsSelection
            return
        }

        feedback = selectedOption.isCorrect ? .correct : .incorrect
    }

    func advance() {
        guard feedback == .correct else { return }
        currentIndex = isLastExercise ? 0 : currentIndex + 1
        selectedOption = nil
        feedback = nil
    }
}

struct LearnView: View {
    @State private var viewModel = LearnViewModel()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    LearnHeaderView()
                    DailyProgressCard(progress: viewModel.progress)
                    LessonPathView(lessons: viewModel.lessons)
                }
                .padding(20)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Learn")
            .navigationDestination(for: Lesson.self) { lesson in
                LessonFlowView(lesson: lesson)
            }
        }
    }
}

private struct LearnHeaderView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Ghalghai mott")
                .font(.largeTitle)
                .bold()
            Text("Beginner Ingush course")
                .font(.title3)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private struct DailyProgressCard: View {
    let progress: UserProgress

    var body: some View {
        HStack(spacing: 16) {
            ProgressBadge(progress: progress.dailyGoalProgress)
            VStack(alignment: .leading, spacing: 4) {
                Text("Daily Progress")
                    .font(.headline)
                Text(progress.dailyGoalText)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Image(systemName: "flame.fill")
                .font(.title2)
                .foregroundStyle(.orange)
                .accessibilityHidden(true)
        }
        .padding(16)
        .cardBackground()
    }
}

private struct LessonPathView: View {
    let lessons: [Lesson]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Beginner Path")
                .font(.headline)
            VStack(spacing: 12) {
                ForEach(lessons) { lesson in
                    LessonCard(lesson: lesson)
                }
            }
        }
    }
}

private struct LessonCard: View {
    let lesson: Lesson

    var body: some View {
        if lesson.isLocked {
            LessonCardContent(lesson: lesson)
                .opacity(0.62)
                .accessibilityLabel("\(lesson.title), locked")
        } else {
            NavigationLink(value: lesson) {
                LessonCardContent(lesson: lesson)
            }
            .buttonStyle(.plain)
        }
    }
}

private struct LessonCardContent: View {
    let lesson: Lesson

    var body: some View {
        HStack(spacing: 16) {
            LessonStatusIcon(lesson: lesson)
            VStack(alignment: .leading, spacing: 6) {
                Text(lesson.title)
                    .font(.headline)
                    .foregroundStyle(.primary)
                Text(lesson.subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                ProgressView(value: lesson.progress)
                    .tint(.green)
            }
            Spacer()
            Image(systemName: lesson.isLocked ? "lock.fill" : "chevron.right")
                .foregroundStyle(.tertiary)
                .accessibilityHidden(true)
        }
        .padding(16)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(.rect(cornerRadius: 16, style: .continuous))
    }
}

private struct LessonStatusIcon: View {
    let lesson: Lesson

    var body: some View {
        ZStack {
            Circle()
                .fill(lesson.isLocked ? Color(.tertiarySystemFill) : Color.green.opacity(0.18))
            Image(systemName: lesson.progress >= 1 ? "checkmark" : "book.closed")
                .font(.headline)
                .foregroundStyle(lesson.isLocked ? .secondary : .green)
                .accessibilityHidden(true)
        }
        .frame(width: 48, height: 48)
    }
}

struct LessonFlowView: View {
    @Environment(AudioManager.self) private var audioManager
    @State private var viewModel: LessonFlowViewModel

    init(lesson: Lesson) {
        _viewModel = State(initialValue: LessonFlowViewModel(lesson: lesson))
    }

    var body: some View {
        VStack(spacing: 0) {
            ProgressView(value: viewModel.progress)
                .tint(.green)
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(.bar)

            ScrollView {
                ExerciseContentView(
                    exercise: viewModel.currentExercise,
                    selectedOption: viewModel.selectedOption,
                    selectOption: viewModel.select,
                    playAudio: playAudio
                )
                .padding(20)
            }
            .background(Color(.systemGroupedBackground))

            LessonActionBar(
                feedback: viewModel.feedback,
                isCorrect: viewModel.feedback == .correct,
                isLastExercise: viewModel.isLastExercise,
                checkAnswer: checkAnswer,
                continueAction: continueLesson
            )
        }
        .navigationTitle(viewModel.lesson.title)
        .navigationBarTitleDisplayMode(.inline)
    }

    private func playAudio() {
        audioManager.playPlaceholder(audioFileName: viewModel.currentExercise.audioFileName)
    }

    private func checkAnswer() {
        withAnimation(.snappy) { viewModel.checkAnswer() }
    }

    private func continueLesson() {
        withAnimation(.snappy) { viewModel.advance() }
    }
}

private struct ExerciseContentView: View {
    let exercise: Exercise
    let selectedOption: ExerciseOption?
    let selectOption: (ExerciseOption) -> Void
    let playAudio: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            ExercisePromptView(exercise: exercise, playAudio: playAudio)
            switch exercise.kind {
            case .multipleChoiceTranslation, .listening:
                MultipleChoiceExerciseView(options: exercise.options, selectedOption: selectedOption, selectOption: selectOption)
            case .wordMatching:
                WordMatchingPlaceholderView(answer: exercise.correctAnswer)
            }
        }
    }
}

private struct ExercisePromptView: View {
    let exercise: Exercise
    let playAudio: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Label(exercise.kind.labelTitle, systemImage: exercise.kind.systemImage)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Text(exercise.prompt)
                .font(.title2)
                .bold()
            if exercise.audioFileName != nil || exercise.kind == .listening {
                Button("Play Audio", systemImage: "speaker.wave.2.fill", action: playAudio)
                    .buttonStyle(.bordered)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .cardBackground()
    }
}

private struct MultipleChoiceExerciseView: View {
    let options: [ExerciseOption]
    let selectedOption: ExerciseOption?
    let selectOption: (ExerciseOption) -> Void

    var body: some View {
        VStack(spacing: 12) {
            ForEach(options) { option in
                Button {
                    selectOption(option)
                } label: {
                    HStack {
                        Text(option.text)
                            .foregroundStyle(.primary)
                        Spacer()
                        if selectedOption == option {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(.green)
                                .accessibilityHidden(true)
                        }
                    }
                    .padding(16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(selectedOption == option ? Color.green.opacity(0.16) : Color(.secondarySystemGroupedBackground))
                    .clipShape(.rect(cornerRadius: 14, style: .continuous))
                }
                .buttonStyle(.plain)
            }
        }
    }
}

private struct WordMatchingPlaceholderView: View {
    let answer: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Matching foundation", systemImage: "rectangle.stack")
                .font(.headline)
            Text("This placeholder reserves the lesson step for a native drag-and-match interaction later.")
                .foregroundStyle(.secondary)
            if let answer {
                Text(answer)
                    .font(.callout)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(.rect(cornerRadius: 16, style: .continuous))
    }
}

private struct LessonActionBar: View {
    let feedback: ExerciseFeedback?
    let isCorrect: Bool
    let isLastExercise: Bool
    let checkAnswer: () -> Void
    let continueAction: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            if let feedback {
                FeedbackView(feedback: feedback)
            }
            if isCorrect {
                Button(isLastExercise ? "Finish" : "Continue", systemImage: "arrow.right", action: continueAction)
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
            } else {
                Button("Check", systemImage: "checkmark", action: checkAnswer)
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(20)
        .background(.bar)
    }
}

private struct FeedbackView: View {
    let feedback: ExerciseFeedback

    var body: some View {
        Label(feedback.message, systemImage: feedback.systemImage)
            .font(.subheadline)
            .bold()
            .foregroundStyle(feedback.color)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private extension ExerciseKind {
    var labelTitle: String {
        switch self {
        case .multipleChoiceTranslation: "Translation"
        case .wordMatching: "Word Matching"
        case .listening: "Listening"
        }
    }

    var systemImage: String {
        switch self {
        case .multipleChoiceTranslation: "text.bubble"
        case .wordMatching: "rectangle.connected.to.line.below"
        case .listening: "ear"
        }
    }
}

private extension ExerciseFeedback {
    var message: String {
        switch self {
        case .correct: "Correct"
        case .incorrect: "Try again"
        case .needsSelection: "Choose an answer first"
        }
    }

    var systemImage: String {
        switch self {
        case .correct: "checkmark.circle.fill"
        case .incorrect: "xmark.circle.fill"
        case .needsSelection: "exclamationmark.circle.fill"
        }
    }

    var color: Color {
        switch self {
        case .correct: .green
        case .incorrect: .red
        case .needsSelection: .orange
        }
    }
}
