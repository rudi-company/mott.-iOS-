import SwiftUI

struct LessonFlowView: View {
    @Environment(AudioManager.self) private var audioManager
    @State private var viewModel: LessonFlowViewModel

    init(lesson: Lesson) {
        _viewModel = State(initialValue: LessonFlowViewModel(lesson: lesson))
    }

    var body: some View {
        VStack(spacing: 0) {
            LessonProgressHeader(progress: viewModel.progress)

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
        withAnimation(.snappy) {
            viewModel.checkAnswer()
        }
    }

    private func continueLesson() {
        withAnimation(.snappy) {
            viewModel.advance()
        }
    }
}

private struct LessonProgressHeader: View {
    let progress: Double

    var body: some View {
        ProgressView(value: progress)
            .tint(.green)
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(.bar)
            .accessibilityLabel("Lesson progress")
            .accessibilityValue(progress, format: .percent.precision(.fractionLength(0)))
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
                MultipleChoiceExerciseView(
                    options: exercise.options,
                    selectedOption: selectedOption,
                    selectOption: selectOption
                )
            case .wordMatching:
                WordMatchingPlaceholderView(answer: exercise.correctAnswer)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private struct ExercisePromptView: View {
    let exercise: Exercise
    let playAudio: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            ExerciseKindLabel(kind: exercise.kind)

            Text(exercise.prompt)
                .font(.title2)
                .bold()
                .fixedSize(horizontal: false, vertical: true)

            if exercise.audioFileName != nil || exercise.kind == .listening {
                Button("Play Audio", systemImage: "speaker.wave.2.fill", action: playAudio)
                    .buttonStyle(.bordered)
            }
        }
        .padding(20)
        .cardBackground()
    }
}

private struct ExerciseKindLabel: View {
    let kind: ExerciseKind

    var body: some View {
        Label(title, systemImage: systemImage)
            .font(.subheadline)
            .foregroundStyle(.secondary)
    }

    private var title: String {
        switch kind {
        case .multipleChoiceTranslation:
            "Translation"
        case .wordMatching:
            "Word Matching"
        case .listening:
            "Listening"
        }
    }

    private var systemImage: String {
        switch kind {
        case .multipleChoiceTranslation:
            "text.bubble"
        case .wordMatching:
            "rectangle.connected.to.line.below"
        case .listening:
            "ear"
        }
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
                            .font(.body)
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
                    .background(optionBackground(for: option))
                    .clipShape(.rect(cornerRadius: 14, style: .continuous))
                }
                .buttonStyle(.plain)
            }
        }
    }

    private func optionBackground(for option: ExerciseOption) -> some ShapeStyle {
        selectedOption == option ? Color.green.opacity(0.16) : Color(.secondarySystemGroupedBackground)
    }
}

private struct WordMatchingPlaceholderView: View {
    let answer: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Matching foundation", systemImage: "rectangle.stack")
                .font(.headline)

            Text("This placeholder reserves the lesson step for a native drag-and-match interaction later.")
                .font(.body)
                .foregroundStyle(.secondary)

            if let answer {
                Text(answer)
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .padding(.top, 4)
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
                    .frame(maxWidth: .infinity)
            } else {
                Button("Check", systemImage: "checkmark", action: checkAnswer)
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .frame(maxWidth: .infinity)
            }
        }
        .padding(20)
        .background(.bar)
    }
}

private struct FeedbackView: View {
    let feedback: ExerciseFeedback

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: systemImage)
                .accessibilityHidden(true)

            Text(message)
                .font(.subheadline)
                .bold()
        }
        .foregroundStyle(foregroundStyle)
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var message: String {
        switch feedback {
        case .correct:
            "Correct"
        case .incorrect:
            "Try again"
        case .needsSelection:
            "Choose an answer first"
        }
    }

    private var systemImage: String {
        switch feedback {
        case .correct:
            "checkmark.circle.fill"
        case .incorrect:
            "xmark.circle.fill"
        case .needsSelection:
            "exclamationmark.circle.fill"
        }
    }

    private var foregroundStyle: Color {
        switch feedback {
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
        LessonFlowView(lesson: MockCourseData.lessons[0])
            .environment(AudioManager())
    }
}
