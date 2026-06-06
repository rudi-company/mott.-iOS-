import SwiftUI

struct LearnView: View {
    @State private var viewModel = LearnViewModel()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    LearnHeaderView()
                    DailyProgressCard(progress: viewModel.progress)
                    LessonPathView(lessons: viewModel.lessons)
                }
                .padding(20)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Learn")
            .navigationDestination(for: Lesson.self) { lesson in
                LessonFlowView(lesson: lesson)
            }
        }
    }
}

private struct LearnHeaderView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Ghalghai mott")
                .font(.largeTitle)
                .bold()

            Text("Beginner Ingush course")
                .font(.title3)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private struct DailyProgressCard: View {
    let progress: UserProgress

    var body: some View {
        HStack(spacing: 16) {
            ProgressBadge(progress: progress.dailyGoalProgress)

            VStack(alignment: .leading, spacing: 4) {
                Text("Daily Progress")
                    .font(.headline)

                Text(progress.dailyGoalText)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Image(systemName: "flame.fill")
                .font(.title2)
                .foregroundStyle(.orange)
                .accessibilityHidden(true)
        }
        .padding(16)
        .cardBackground()
    }
}

private struct LessonPathView: View {
    let lessons: [Lesson]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Beginner Path")
                .font(.headline)

            VStack(spacing: 12) {
                ForEach(lessons) { lesson in
                    LessonCard(lesson: lesson)
                }
            }
        }
    }
}

private struct LessonCard: View {
    let lesson: Lesson

    var body: some View {
        if lesson.isLocked {
            LessonCardContent(lesson: lesson)
                .opacity(0.62)
                .accessibilityLabel("\(lesson.title), locked")
        } else {
            NavigationLink(value: lesson) {
                LessonCardContent(lesson: lesson)
            }
            .buttonStyle(.plain)
        }
    }
}

private struct LessonCardContent: View {
    let lesson: Lesson

    var body: some View {
        HStack(spacing: 16) {
            LessonStatusIcon(lesson: lesson)

            VStack(alignment: .leading, spacing: 6) {
                Text(lesson.title)
                    .font(.headline)
                    .foregroundStyle(.primary)

                Text(lesson.subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                ProgressView(value: lesson.progress)
                    .tint(.green)
                    .accessibilityValue(lesson.progress, format: .percent.precision(.fractionLength(0)))
            }

            Spacer()

            Image(systemName: lesson.isLocked ? "lock.fill" : "chevron.right")
                .font(.body)
                .foregroundStyle(.tertiary)
                .accessibilityHidden(true)
        }
        .padding(16)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(.rect(cornerRadius: 16, style: .continuous))
    }
}

private struct LessonStatusIcon: View {
    let lesson: Lesson

    var body: some View {
        ZStack {
            Circle()
                .fill(lesson.isLocked ? Color(.tertiarySystemFill) : Color.green.opacity(0.18))

            Image(systemName: lesson.progress >= 1 ? "checkmark" : "book.closed")
                .font(.headline)
                .foregroundStyle(lesson.isLocked ? .secondary : .green)
                .accessibilityHidden(true)
        }
        .frame(width: 48, height: 48)
    }
}

#Preview {
    LearnView()
        .environment(AudioManager())
}
