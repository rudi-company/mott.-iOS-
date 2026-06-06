import SwiftUI

/// Shows source-safe metadata and draft content blocks for one course lesson.
struct CourseLessonDetailView: View {
    let course: Course
    let lesson: CourseLesson

    private var topicsByID: [String: GrammarTopic] {
        Dictionary(uniqueKeysWithValues: course.grammarTopics.map { ($0.id, $0) })
    }

    private var lexemesByID: [String: Lexeme] {
        Dictionary(uniqueKeysWithValues: course.lexemes.map { ($0.id, $0) })
    }

    private var exercisesByID: [String: CourseLibrary.Exercise] {
        Dictionary(uniqueKeysWithValues: course.exercises.map { ($0.id, $0) })
    }

    private var topics: [GrammarTopic] {
        lesson.grammarTopicIDs.compactMap { topicsByID[$0] }
    }

    private var lexemes: [Lexeme] {
        lesson.lexemeIDs.compactMap { lexemesByID[$0] }
    }

    private var exercises: [CourseLibrary.Exercise] {
        lesson.exerciseIDs.compactMap { exercisesByID[$0] }
    }

    var body: some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: 12) {
                    Text(lesson.title)
                        .font(.title2)
                        .bold()

                    Text(lesson.description)
                        .font(.body)
                        .foregroundStyle(.secondary)

                    Label("\(lesson.estimatedMinutes) minutes", systemImage: "clock")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 4)
            }

            Section("Teaching Blocks") {
                ForEach(lesson.blocks) { block in
                    LessonBlockRow(block: block)
                }
            }

            Section("Grammar Topics") {
                if topics.isEmpty {
                    Text("No grammar topics linked yet")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(topics) { topic in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(topic.title)
                                .font(.headline)
                            Text(topic.id)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }

            Section("Vocabulary") {
                Label("\(lexemes.count) placeholder items", systemImage: "textformat.abc")
                ForEach(lexemes) { lexeme in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(lexeme.ingush)
                            .font(.headline)
                        Text("\(lexeme.transliteration) · \(lexeme.englishGloss)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
            }

            Section("Exercises") {
                Label("\(exercises.count) placeholder exercises", systemImage: "checklist")
                ForEach(exercises) { exercise in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(exercise.title)
                            .font(.headline)
                        Text(exercise.kind.rawValue)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }

            Section("Source References") {
                ForEach(lesson.sourceReferences) { reference in
                    SourceReferenceRow(reference: reference)
                }
            }
        }
        .navigationTitle("Lesson")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct LessonBlockRow: View {
    let block: LessonBlock

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(block.title)
                .font(.headline)

            Text(block.body)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Text(block.kind.rawValue)
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
        .padding(.vertical, 4)
    }
}

private struct SourceReferenceRow: View {
    let reference: SourceReference

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(reference.sourceTitle)
                .font(.headline)

            Text(reference.author)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            HStack(spacing: 8) {
                if let chapter = reference.chapter {
                    Text("Chapter \(chapter)")
                }

                if let section = reference.section {
                    Text("Section \(section)")
                }

                if let page = reference.page {
                    Text("Page \(page)")
                }
            }
            .font(.caption)
            .foregroundStyle(.secondary)

            Text(reference.note)
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    NavigationStack {
        CourseLessonDetailView(
            course: CourseLibrarySeed.course,
            lesson: CourseLibrarySeed.course.levels[0].units[0].lessons[0]
        )
    }
}
