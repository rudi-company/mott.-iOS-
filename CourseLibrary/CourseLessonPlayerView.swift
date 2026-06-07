import SwiftUI
import Observation

private enum CourseLessonPlayerStep: Identifiable, Hashable {
    case block(LessonBlock)
    case exercise(CourseLibrary.Exercise)

    var id: String {
        switch self {
        case .block(let block):
            block.id
        case .exercise(let exercise):
            exercise.id
        }
    }
}

private enum CourseLessonPlayerFeedback: Equatable {
    case correct
    case incorrect
    case needsSelection
}

@MainActor
@Observable
private final class CourseLessonPlayerViewModel {
    let course: Course
    let lesson: CourseLesson
    let steps: [CourseLessonPlayerStep]

    private(set) var currentIndex = 0
    var selectedChoice: String?
    var feedback: CourseLessonPlayerFeedback?

    var currentStep: CourseLessonPlayerStep {
        steps[currentIndex]
    }

    var progress: Double {
        guard !steps.isEmpty else { return 0 }
        return Double(currentIndex + 1) / Double(steps.count)
    }

    var isLastStep: Bool {
        currentIndex == steps.count - 1
    }

    var canCheckAnswer: Bool {
        if case .exercise = currentStep {
            return feedback != .correct
        }
        return false
    }

    init(course: Course, lesson: CourseLesson) {
        self.course = course
        self.lesson = lesson

        let exercisesByID = Dictionary(uniqueKeysWithValues: course.exercises.map { ($0.id, $0) })
        let lessonExercises = lesson.exerciseIDs.compactMap { exercisesByID[$0] }
        self.steps = lesson.blocks.map(CourseLessonPlayerStep.block) + lessonExercises.map(CourseLessonPlayerStep.exercise)
    }

    func selectChoice(_ choice: String) {
        selectedChoice = choice
        feedback = nil
    }

    func checkAnswer() {
        guard case .exercise(let exercise) = currentStep, let item = exercise.items.first else {
            feedback = .correct
            return
        }

        guard let selectedChoice else {
            feedback = .needsSelection
            return
        }

        feedback = selectedChoice == item.correctAnswer ? .correct : .incorrect
    }

    func advance() {
        guard !isLastStep else { return }
        currentIndex += 1
        selectedChoice = nil
        feedback = nil
    }
}

struct CourseLessonPlayerView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(AudioManager.self) private var audioManager
    @State private var viewModel: CourseLessonPlayerViewModel

    init(course: Course, lesson: CourseLesson) {
        _viewModel = State(initialValue: CourseLessonPlayerViewModel(course: course, lesson: lesson))
    }

    var body: some View {
        VStack(spacing: 0) {
            LessonPlayerProgressView(progress: viewModel.progress)

            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    LessonPlayerHeaderView(lesson: viewModel.lesson)
                    LessonPlayerStepView(
                        step: viewModel.currentStep,
                        selectedChoice: viewModel.selectedChoice,
                        selectChoice: viewModel.selectChoice,
                        playAudio: playAudio
                    )
                }
                .padding(20)
            }
            .background(Color(.systemGroupedBackground))

            LessonPlayerActionBar(
                feedback: viewModel.feedback,
                isExercise: viewModel.canCheckAnswer,
                isLastStep: viewModel.isLastStep,
                checkAnswer: checkAnswer,
                continueAction: continueLesson
            )
        }
        .navigationTitle(viewModel.lesson.title)
        .navigationBarTitleDisplayMode(.inline)
        .settingsToolbar()
    }

    private func playAudio() {
        if case .exercise(let exercise) = viewModel.currentStep {
            audioManager.playPlaceholder(audioFileName: exercise.audioReference?.fileName)
        }
    }

    private func checkAnswer() {
        withAnimation(.snappy) {
            viewModel.checkAnswer()
        }
    }

    private func continueLesson() {
        withAnimation(.snappy) {
            if viewModel.isLastStep {
                dismiss()
            } else {
                viewModel.advance()
            }
        }
    }
}

private struct LessonPlayerProgressView: View {
    let progress: Double

    var body: some View {
        ProgressView(value: progress)
            .tint(.green)
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(.bar)
            .accessibilityLabel("Lesson progress")
            .accessibilityValue(progress.formatted(.percent.precision(.fractionLength(0))))
    }
}

private struct LessonPlayerHeaderView: View {
    let lesson: CourseLesson

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(lesson.title)
                .font(.title2)
                .bold()

            Text(lesson.description)
                .font(.body)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private struct LessonPlayerStepView: View {
    let step: CourseLessonPlayerStep
    let selectedChoice: String?
    let selectChoice: (String) -> Void
    let playAudio: () -> Void

    var body: some View {
        switch step {
        case .block(let block):
            LessonBlockStepView(block: block)
        case .exercise(let exercise):
            ExerciseStepView(
                exercise: exercise,
                selectedChoice: selectedChoice,
                selectChoice: selectChoice,
                playAudio: playAudio
            )
        }
    }
}

private struct LessonBlockStepView: View {
    let block: LessonBlock

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Label(block.kind.playerTitle, systemImage: block.kind.systemImage)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Text(block.title)
                .font(.title3)
                .bold()

            Text(block.body)
                .font(.body)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .cardBackground()
    }
}

private struct ExerciseStepView: View {
    let exercise: CourseLibrary.Exercise
    let selectedChoice: String?
    let selectChoice: (String) -> Void
    let playAudio: () -> Void

    private var item: CourseLibrary.ExerciseItem? {
        exercise.items.first
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 16) {
                Label(exercise.kind.playerTitle, systemImage: exercise.kind.systemImage)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Text(item?.prompt ?? exercise.title)
                    .font(.title3)
                    .bold()
                    .fixedSize(horizontal: false, vertical: true)

                if exercise.kind == .listening || exercise.audioReference != nil {
                    Button("Play Audio", systemImage: "speaker.wave.2.fill", action: playAudio)
                        .buttonStyle(.bordered)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(20)
            .cardBackground()

            if let item, !item.choices.isEmpty {
                VStack(spacing: 12) {
                    ForEach(item.choices, id: \.self) { choice in
                        Button {
                            selectChoice(choice)
                        } label: {
                            HStack(spacing: 12) {
                                Text(choice)
                                    .foregroundStyle(.primary)
                                    .frame(maxWidth: .infinity, alignment: .leading)

                                if selectedChoice == choice {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundStyle(.green)
                                        .accessibilityHidden(true)
                                }
                            }
                            .padding(16)
                            .background(choiceBackground(for: choice))
                            .clipShape(.rect(cornerRadius: 14, style: .continuous))
                        }
                        .buttonStyle(.plain)
                    }
                }
            } else {
                ExercisePlaceholderView(kind: exercise.kind)
            }
        }
    }

    private func choiceBackground(for choice: String) -> Color {
        selectedChoice == choice ? Color.green.opacity(0.16) : Color(.secondarySystemGroupedBackground)
    }
}

private struct ExercisePlaceholderView: View {
    let kind: CourseLibrary.ExerciseKind

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Practice foundation", systemImage: kind.systemImage)
                .font(.headline)

            Text("This step is reserved for a native interaction in a later pass.")
                .font(.body)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(.rect(cornerRadius: 16, style: .continuous))
    }
}

private struct LessonPlayerActionBar: View {
    let feedback: CourseLessonPlayerFeedback?
    let isExercise: Bool
    let isLastStep: Bool
    let checkAnswer: () -> Void
    let continueAction: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            if let feedback {
                LessonPlayerFeedbackView(feedback: feedback)
            }

            if shouldShowContinueButton {
                Button(isLastStep ? "Finish" : "Continue", systemImage: isLastStep ? "checkmark" : "arrow.right", action: continueAction)
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

    private var shouldShowContinueButton: Bool {
        !isExercise || feedback == .correct
    }
}

private struct LessonPlayerFeedbackView: View {
    let feedback: CourseLessonPlayerFeedback

    var body: some View {
        Label(feedback.message, systemImage: feedback.systemImage)
            .font(.subheadline)
            .bold()
            .foregroundStyle(feedback.color)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private extension LessonBlockKind {
    var playerTitle: String {
        switch self {
        case .concept:
            "Concept"
        case .pattern:
            "Pattern"
        case .example:
            "Example"
        case .practicePrompt:
            "Practice"
        }
    }

    var systemImage: String {
        switch self {
        case .concept:
            "lightbulb"
        case .pattern:
            "text.alignleft"
        case .example:
            "quote.bubble"
        case .practicePrompt:
            "checklist"
        }
    }
}

private extension CourseLibrary.ExerciseKind {
    var playerTitle: String {
        switch self {
        case .multipleChoice:
            "Choose"
        case .listening:
            "Listening"
        case .matching:
            "Match"
        case .pronunciation:
            "Pronunciation"
        case .caseEndingDrill:
            "Case Practice"
        case .genderAgreementDrill:
            "Agreement"
        case .verbConjugationDrill:
            "Verb Practice"
        case .reading:
            "Reading"
        }
    }

    var systemImage: String {
        switch self {
        case .multipleChoice:
            "checkmark.circle"
        case .listening:
            "ear"
        case .matching:
            "rectangle.connected.to.line.below"
        case .pronunciation:
            "waveform.and.mic"
        case .caseEndingDrill:
            "textformat.abc.dottedunderline"
        case .genderAgreementDrill:
            "person.2"
        case .verbConjugationDrill:
            "arrow.triangle.branch"
        case .reading:
            "book.pages"
        }
    }
}

private extension CourseLessonPlayerFeedback {
    var message: String {
        switch self {
        case .correct:
            "Correct"
        case .incorrect:
            "Try again"
        case .needsSelection:
            "Choose an answer first"
        }
    }

    var systemImage: String {
        switch self {
        case .correct:
            "checkmark.circle.fill"
        case .incorrect:
            "xmark.circle.fill"
        case .needsSelection:
            "exclamationmark.circle.fill"
        }
    }

    var color: Color {
        switch self {
        case .correct:
            .green
        case .incorrect:
            .red
        case .needsSelection:
            .orange
        }
    }
}

#Preview {
    NavigationStack {
        CourseLessonPlayerView(
            course: CourseLibrarySeed.course,
            lesson: CourseLibrarySeed.course.levels[0].units[0].lessons[0]
        )
        .environment(AudioManager())
    }
}
