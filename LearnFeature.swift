import SwiftUI
import Observation

@MainActor
@Observable
final class LearnViewModel {
    let course: Course
    let validationIssues: [CourseLibraryValidationIssue]
    let dailyGoalProgress = 0.6
    let dailyGoalText = "3 of 5 exercises"

    var totalUnitCount: Int {
        course.levels.reduce(0) { $0 + $1.units.count }
    }

    var totalLessonCount: Int {
        course.levels.flatMap(\.units).reduce(0) { $0 + $1.lessons.count }
    }

    var nextLesson: CourseLesson? {
        course.levels.first?.units.first?.lessons.first
    }

    init() {
        let repository = CourseLibraryRepository()
        self.course = repository.course(id: "ingush_foundations") ?? CourseLibrarySeed.course
        self.validationIssues = CourseLibraryValidator.validate(course)
    }

    init(course: Course) {
        self.course = course
        self.validationIssues = CourseLibraryValidator.validate(course)
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
                    CourseHeaderView(viewModel: viewModel)
                    ContinueCourseCard(course: viewModel.course, lesson: viewModel.nextLesson)
                    DailyCourseProgressCard(progress: viewModel.dailyGoalProgress, detail: viewModel.dailyGoalText)
                    CoursePathView(course: viewModel.course)

                    if !viewModel.validationIssues.isEmpty {
                        CourseValidationNotice(issueCount: viewModel.validationIssues.count)
                    }
                }
                .padding(20)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Learn")
            .settingsToolbar()
            .navigationDestination(for: CourseLesson.self) { lesson in
                CourseLessonPlayerView(course: viewModel.course, lesson: lesson)
            }
        }
    }
}

private struct CourseHeaderView: View {
    let viewModel: LearnViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Ghalghai mott")
                    .font(.largeTitle)
                    .bold()

                Text(viewModel.course.subtitle)
                    .font(.title3)
                    .foregroundStyle(.secondary)
            }

            HStack(spacing: 12) {
                CourseMetricView(value: viewModel.course.levels.count.formatted(), label: "Levels")
                CourseMetricView(value: viewModel.totalUnitCount.formatted(), label: "Units")
                CourseMetricView(value: viewModel.totalLessonCount.formatted(), label: "Lessons")
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private struct CourseMetricView: View {
    let value: String
    let label: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(value)
                .font(.title3)
                .bold()
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(.rect(cornerRadius: 14, style: .continuous))
    }
}

private struct ContinueCourseCard: View {
    let course: Course
    let lesson: CourseLesson?

    var body: some View {
        if let lesson {
            NavigationLink(value: lesson) {
                HStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(Color.green.opacity(0.18))
                        Image(systemName: "play.fill")
                            .foregroundStyle(.green)
                            .accessibilityHidden(true)
                    }
                    .frame(width: 48, height: 48)

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Continue")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text(lesson.title)
                            .font(.headline)
                            .foregroundStyle(.primary)
                        Text(course.title)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }

                    Spacer()

                    Image(systemName: "chevron.right")
                        .foregroundStyle(.tertiary)
                        .accessibilityHidden(true)
                }
                .padding(16)
                .cardBackground()
            }
            .buttonStyle(.plain)
        }
    }
}

private struct DailyCourseProgressCard: View {
    let progress: Double
    let detail: String

    var body: some View {
        HStack(spacing: 16) {
            ProgressBadge(progress: progress)

            VStack(alignment: .leading, spacing: 4) {
                Text("Today")
                    .font(.headline)
                Text(detail)
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

private struct CoursePathView: View {
    let course: Course

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Course Path")
                .font(.headline)

            ForEach(course.levels) { level in
                CourseLevelSection(level: level)
            }
        }
    }
}

private struct CourseLevelSection: View {
    let level: CourseLevel

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .firstTextBaseline) {
                Text(level.id)
                    .font(.headline)
                Text(level.title)
                    .font(.headline)
                    .foregroundStyle(.secondary)
            }

            VStack(spacing: 12) {
                ForEach(level.units) { unit in
                    CourseUnitCard(unit: unit)
                }
            }
        }
    }
}

private struct CourseUnitCard: View {
    let unit: CourseUnit

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Unit \(unit.sequence)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(unit.title)
                    .font(.headline)
                Text(unit.summary)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }

            VStack(spacing: 0) {
                ForEach(unit.lessons) { lesson in
                    NavigationLink(value: lesson) {
                        CourseLessonPathRow(lesson: lesson)
                    }
                    .buttonStyle(.plain)

                    if lesson.id != unit.lessons.last?.id {
                        Divider()
                            .padding(.leading, 16)
                    }
                }
            }
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(.rect(cornerRadius: 14, style: .continuous))
        }
        .padding(16)
        .background(Color(.tertiarySystemGroupedBackground))
        .clipShape(.rect(cornerRadius: 16, style: .continuous))
    }
}

private struct CourseLessonPathRow: View {
    let lesson: CourseLesson

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "book.closed")
                .foregroundStyle(.green)
                .frame(width: 28)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 4) {
                Text(lesson.title)
                    .font(.subheadline)
                    .foregroundStyle(.primary)
                Text("\(lesson.estimatedMinutes) min · \(lesson.grammarTopicIDs.count) topic")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Text("Draft")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(16)
    }
}

private struct CourseValidationNotice: View {
    let issueCount: Int

    var body: some View {
        Label("\(issueCount) course validation issue", systemImage: "exclamationmark.triangle")
            .font(.subheadline)
            .foregroundStyle(.orange)
            .padding(16)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(.rect(cornerRadius: 16, style: .continuous))
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
