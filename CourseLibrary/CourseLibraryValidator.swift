import Foundation

/// A validation issue found in the bundled course library.
struct CourseLibraryValidationIssue: Identifiable, Hashable {
    let id: String
    let message: String
}

/// Validates seed-course integrity before the library is exposed in production.
enum CourseLibraryValidator {
    /// Returns all validation issues found in a course.
    static func validate(_ course: Course) -> [CourseLibraryValidationIssue] {
        var issues: [CourseLibraryValidationIssue] = []

        issues.append(contentsOf: duplicateIssues(named: "course", ids: [course.id]))
        issues.append(contentsOf: duplicateIssues(named: "level", ids: course.levels.map(\.id)))
        issues.append(contentsOf: duplicateIssues(named: "grammar topic", ids: course.grammarTopics.map(\.id)))
        issues.append(contentsOf: duplicateIssues(named: "lexeme", ids: course.lexemes.map(\.id)))
        issues.append(contentsOf: duplicateIssues(named: "verb", ids: course.verbEntries.map(\.id)))
        issues.append(contentsOf: duplicateIssues(named: "example sentence", ids: course.exampleSentences.map(\.id)))
        issues.append(contentsOf: duplicateIssues(named: "exercise", ids: course.exercises.map(\.id)))

        let units = course.levels.flatMap(\.units)
        let lessons = units.flatMap(\.lessons)
        let lessonIDs = Set(lessons.map(\.id))
        let unitIDs = Set(units.map(\.id))
        let topicIDs = Set(course.grammarTopics.map(\.id))
        let lexemeIDs = Set(course.lexemes.map(\.id))
        let exerciseIDs = Set(course.exercises.map(\.id))

        issues.append(contentsOf: duplicateIssues(named: "unit", ids: units.map(\.id)))
        issues.append(contentsOf: duplicateIssues(named: "lesson", ids: lessons.map(\.id)))

        issues.append(contentsOf: emptyTitleIssues(course, units: units, lessons: lessons))
        issues.append(contentsOf: emptyContainerIssues(course))

        for unit in units where !Set(course.levels.map(\.id)).contains(unit.levelID) {
            issues.append(issue("unit_missing_level_\(unit.id)", "Unit \(unit.id) points to an unknown level."))
        }

        for lesson in lessons {
            if !unitIDs.contains(lesson.unitID) {
                issues.append(issue("lesson_missing_unit_\(lesson.id)", "Lesson \(lesson.id) points to an unknown unit."))
            }

            if lesson.sourceReferences.isEmpty {
                issues.append(issue("lesson_missing_source_\(lesson.id)", "Lesson \(lesson.id) has no source reference."))
            }

            for topicID in lesson.grammarTopicIDs where !topicIDs.contains(topicID) {
                issues.append(issue("lesson_unknown_topic_\(lesson.id)_\(topicID)", "Lesson \(lesson.id) points to unknown grammar topic \(topicID)."))
            }

            for lexemeID in lesson.lexemeIDs where !lexemeIDs.contains(lexemeID) {
                issues.append(issue("lesson_unknown_lexeme_\(lesson.id)_\(lexemeID)", "Lesson \(lesson.id) points to unknown lexeme \(lexemeID)."))
            }

            for exerciseID in lesson.exerciseIDs where !exerciseIDs.contains(exerciseID) {
                issues.append(issue("lesson_unknown_exercise_\(lesson.id)_\(exerciseID)", "Lesson \(lesson.id) points to unknown exercise \(exerciseID)."))
            }
        }

        for exercise in course.exercises where !lessonIDs.contains(exercise.lessonID) {
            issues.append(issue("exercise_unknown_lesson_\(exercise.id)", "Exercise \(exercise.id) points to unknown lesson \(exercise.lessonID)."))
        }

        for lexeme in course.lexemes {
            for lessonID in lexeme.lessonIDs where !lessonIDs.contains(lessonID) {
                issues.append(issue("lexeme_unknown_lesson_\(lexeme.id)_\(lessonID)", "Lexeme \(lexeme.id) points to unknown lesson \(lessonID)."))
            }
        }

        return issues
    }

    private static func duplicateIssues(named kind: String, ids: [String]) -> [CourseLibraryValidationIssue] {
        let groupedIDs = Dictionary(grouping: ids, by: { $0 })
        return groupedIDs.compactMap { id, matches in
            matches.count > 1 ? issue("duplicate_\(kind)_\(id)", "Duplicate \(kind) id: \(id).") : nil
        }
    }

    private static func emptyTitleIssues(_ course: Course, units: [CourseUnit], lessons: [CourseLesson]) -> [CourseLibraryValidationIssue] {
        var issues: [CourseLibraryValidationIssue] = []

        if course.title.isEmpty {
            issues.append(issue("empty_course_title", "Course title is empty."))
        }

        for level in course.levels where level.title.isEmpty {
            issues.append(issue("empty_level_title_\(level.id)", "Level \(level.id) title is empty."))
        }

        for unit in units where unit.title.isEmpty {
            issues.append(issue("empty_unit_title_\(unit.id)", "Unit \(unit.id) title is empty."))
        }

        for lesson in lessons where lesson.title.isEmpty {
            issues.append(issue("empty_lesson_title_\(lesson.id)", "Lesson \(lesson.id) title is empty."))
        }

        return issues
    }

    private static func emptyContainerIssues(_ course: Course) -> [CourseLibraryValidationIssue] {
        var issues: [CourseLibraryValidationIssue] = []

        if course.levels.isEmpty {
            issues.append(issue("empty_course_levels", "Course has no levels."))
        }

        for level in course.levels where level.units.isEmpty {
            issues.append(issue("empty_level_units_\(level.id)", "Level \(level.id) has no units."))
        }

        for unit in course.levels.flatMap(\.units) where unit.lessons.isEmpty {
            issues.append(issue("empty_unit_lessons_\(unit.id)", "Unit \(unit.id) has no lessons."))
        }

        return issues
    }

    private static func issue(_ id: String, _ message: String) -> CourseLibraryValidationIssue {
        CourseLibraryValidationIssue(id: id, message: message)
    }
}
