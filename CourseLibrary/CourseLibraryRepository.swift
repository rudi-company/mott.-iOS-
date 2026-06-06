import Foundation

/// Loads the bundled course library from seed data for now.
struct CourseLibraryRepository {
    private let seedCourse: Course

    init(seedCourse: Course = CourseLibrarySeed.course) {
        self.seedCourse = seedCourse
    }

    /// Returns all bundled courses.
    func courses() -> [Course] {
        [seedCourse]
    }

    /// Returns a bundled course with the requested identifier.
    func course(id: String) -> Course? {
        courses().first { $0.id == id }
    }
}
