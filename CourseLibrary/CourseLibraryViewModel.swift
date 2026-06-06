import Foundation
import Observation

/// View state and lookup helpers for the course-library browser.
@MainActor
@Observable
final class CourseLibraryViewModel {
    private let repository: CourseLibraryRepository

    private(set) var courses: [Course] = []
    private(set) var validationIssues: [CourseLibraryValidationIssue] = []

    var primaryCourse: Course? {
        courses.first
    }

    init(repository: CourseLibraryRepository = CourseLibraryRepository()) {
        self.repository = repository
        loadCourses()
    }

    /// Reloads bundled courses and validates their internal references.
    func loadCourses() {
        courses = repository.courses()
        validationIssues = courses.flatMap { CourseLibraryValidator.validate($0) }
    }

    /// Returns grammar topics keyed by identifier.
    func grammarTopicsByID(for course: Course) -> [String: GrammarTopic] {
        Dictionary(uniqueKeysWithValues: course.grammarTopics.map { ($0.id, $0) })
    }

    /// Returns lexemes keyed by identifier.
    func lexemesByID(for course: Course) -> [String: Lexeme] {
        Dictionary(uniqueKeysWithValues: course.lexemes.map { ($0.id, $0) })
    }

    /// Returns exercises keyed by identifier.
    func exercisesByID(for course: Course) -> [String: CourseLibrary.Exercise] {
        Dictionary(uniqueKeysWithValues: course.exercises.map { ($0.id, $0) })
    }
}
