import SwiftUI

/// Lists lessons inside a course unit.
struct CourseLessonListView: View {
    let course: Course
    let unit: CourseUnit

    var body: some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: 8) {
                    Text(unit.title)
                        .font(.title2)
                        .bold()

                    Text(unit.summary)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 4)
            }

            Section("Lessons") {
                ForEach(unit.lessons) { lesson in
                    NavigationLink(value: lesson) {
                        CourseLessonRow(lesson: lesson)
                    }
                }
            }
        }
        .navigationTitle("Unit \(unit.sequence)")
        .settingsToolbar()
        .navigationDestination(for: CourseLesson.self) { lesson in
            CourseLessonDetailView(course: course, lesson: lesson)
        }
    }
}

private struct CourseLessonRow: View {
    let lesson: CourseLesson

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(lesson.title)
                .font(.headline)

            Text(lesson.description)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(2)

            Label("\(lesson.estimatedMinutes) min", systemImage: "clock")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    NavigationStack {
        CourseLessonListView(course: CourseLibrarySeed.course, unit: CourseLibrarySeed.course.levels[0].units[0])
    }
}
