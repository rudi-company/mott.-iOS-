import SwiftUI

/// Standalone browser for bundled language courses.
struct CourseLibraryView: View {
    @State private var viewModel = CourseLibraryViewModel()

    var body: some View {
        NavigationStack {
            List {
                if let course = viewModel.primaryCourse {
                    CourseSummarySection(course: course, issueCount: viewModel.validationIssues.count)

                    Section("Levels") {
                        ForEach(course.levels) { level in
                            NavigationLink(value: level) {
                                CourseLevelRow(level: level)
                            }
                        }
                    }

                    if !viewModel.validationIssues.isEmpty {
                        Section("Validation") {
                            ForEach(viewModel.validationIssues.prefix(5)) { issue in
                                Label(issue.message, systemImage: "exclamationmark.triangle")
                                    .foregroundStyle(.orange)
                            }
                        }
                    }
                } else {
                    ContentUnavailableView("No Courses", systemImage: "books.vertical", description: Text("Bundled course data is not available."))
                }
            }
            .navigationTitle("Course Library")
            .settingsToolbar()
            .navigationDestination(for: CourseLevel.self) { level in
                if let course = viewModel.primaryCourse {
                    CourseUnitListView(course: course, level: level)
                }
            }
        }
    }
}

private struct CourseSummarySection: View {
    let course: Course
    let issueCount: Int

    var body: some View {
        Section {
            VStack(alignment: .leading, spacing: 8) {
                Text(course.title)
                    .font(.title2)
                    .bold()

                Text(course.subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                HStack(spacing: 12) {
                    Label(course.status.rawValue.capitalized, systemImage: "doc.badge.gearshape")
                    Label("\(course.levels.count) levels", systemImage: "square.stack.3d.up")
                    Label("\(issueCount) issues", systemImage: issueCount == 0 ? "checkmark.seal" : "exclamationmark.triangle")
                }
                .font(.caption)
                .foregroundStyle(.secondary)
            }
            .padding(.vertical, 4)
        }
    }
}

private struct CourseLevelRow: View {
    let level: CourseLevel

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(level.id)
                    .font(.headline)
                Text(level.title)
                    .font(.headline)
            }

            Text("\(level.units.count) units")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    CourseLibraryView()
}
