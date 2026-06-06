import Foundation
import Observation

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

    var currentExercise: Exercise {
        lesson.exercises[currentIndex]
    }

    var progress: Double {
        guard !lesson.exercises.isEmpty else { return 0 }
        return Double(currentIndex + 1) / Double(lesson.exercises.count)
    }

    var isLastExercise: Bool {
        currentIndex == lesson.exercises.count - 1
    }

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

        if isLastExercise {
            currentIndex = 0
        } else {
            currentIndex += 1
        }

        selectedOption = nil
        feedback = nil
    }
}
