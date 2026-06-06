import SwiftUI

/// Lists units inside a course level.
struct CourseUnitListView: View {
    let course: Course
    let level: CourseLevel

    var body: some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: 8) {
                    Text(level.title)
                        .font(.title2)
                        .bold()
                    Text(level.subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 4)
            }

            Section("Units") {
                ForEach(level.units) { unit in
                    NavigationLink(value: unit) {
                        CourseUnitRow(unit: unit)
                    }
                }
            }
        }
        .navigationTitle(level.id)
        .navigationDestination(for: CourseUnit.self) { unit in
            CourseLessonListView(course: course, unit: unit)
        }
    }
}

private struct CourseUnitRow: View {
    let unit: CourseUnit

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Unit \(unit.sequence)")
                .font(.caption)
                .foregroundStyle(.secondary)

            Text(unit.title)
                .font(.headline)

            Text("\(unit.lessons.count) lessons")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    NavigationStack {
        CourseUnitListView(course: CourseLibrarySeed.course, level: CourseLibrarySeed.course.levels[0])
    }
}
