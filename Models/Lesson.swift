import Foundation

struct Lesson: Identifiable, Hashable {
    let id: UUID
    let title: String
    let subtitle: String
    let progress: Double
    let isLocked: Bool
    let exercises: [Exercise]

    init(
        id: UUID = UUID(),
        title: String,
        subtitle: String,
        progress: Double,
        isLocked: Bool,
        exercises: [Exercise]
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.progress = progress
        self.isLocked = isLocked
        self.exercises = exercises
    }
}
