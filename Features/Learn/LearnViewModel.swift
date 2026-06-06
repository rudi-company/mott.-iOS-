import Foundation
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
