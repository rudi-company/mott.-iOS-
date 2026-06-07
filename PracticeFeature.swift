import SwiftUI

struct PracticeView: View {
    @Environment(AppSettings.self) private var appSettings
    private let progress = MockCourseData.userProgress
    private let weakWords = MockCourseData.weakWords

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    ContinuePracticeCard(progress: progress)
                    WeakWordsSection(words: weakWords, baseLanguage: appSettings.baseLanguage)
                    PracticePlaceholderGrid()
                }
                .padding(20)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Practice")
            .settingsToolbar()
        }
    }
}

private struct ContinuePracticeCard: View {
    let progress: UserProgress

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 12) {
                Image(systemName: "play.circle.fill")
                    .font(.largeTitle)
                    .foregroundStyle(.green)
                    .accessibilityHidden(true)
                VStack(alignment: .leading, spacing: 4) {
                    Text("Continue Practice")
                        .font(.headline)
                    Text(progress.dailyGoalText)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Spacer()
            }
            Button("Start", systemImage: "arrow.right") {}
                .buttonStyle(.borderedProminent)
        }
        .padding(20)
        .cardBackground()
    }
}

private struct WeakWordsSection: View {
    let words: [Word]
    let baseLanguage: BaseLanguage

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Weak Words")
                .font(.headline)
            VStack(spacing: 0) {
                ForEach(words) { word in
                    WeakWordRow(word: word, baseLanguage: baseLanguage)
                    if word != words.last {
                        Divider().padding(.leading, 16)
                    }
                }
            }
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(.rect(cornerRadius: 16, style: .continuous))
        }
    }
}

private struct WeakWordRow: View {
    let word: Word
    let baseLanguage: BaseLanguage

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(word.ingush).font(.headline)
                Text(word.meaning(in: baseLanguage)).font(.subheadline).foregroundStyle(.secondary)
            }
            Spacer()
            Image(systemName: "arrow.triangle.2.circlepath")
                .foregroundStyle(.tertiary)
                .accessibilityHidden(true)
        }
        .padding(16)
    }
}

private struct PracticePlaceholderGrid: View {
    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 220), spacing: 12)], spacing: 12) {
            PracticeModeCard(title: "Listening Practice", subtitle: "Recognize spoken words", systemImage: "ear")
            PracticeModeCard(title: "Pronunciation Practice", subtitle: "Prepare for speaking review", systemImage: "waveform.and.mic")
        }
    }
}

private struct PracticeModeCard: View {
    let title: String
    let subtitle: String
    let systemImage: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(systemName: systemImage)
                .font(.title2)
                .foregroundStyle(.green)
                .accessibilityHidden(true)
            Text(title).font(.headline)
            Text(subtitle).font(.subheadline).foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(.rect(cornerRadius: 16, style: .continuous))
    }
}
