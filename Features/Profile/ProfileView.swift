import SwiftUI

struct ProfileView: View {
    private let progress = MockCourseData.userProgress

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    ProfileHeaderView()
                    ProfileStatsGrid(progress: progress)
                    SettingsPlaceholderView()
                }
                .padding(20)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Profile")
        }
    }
}

private struct ProfileHeaderView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "person.crop.circle.fill")
                .font(.system(.largeTitle))
                .foregroundStyle(.secondary)
                .accessibilityHidden(true)

            Text("Learner")
                .font(.title2)
                .bold()

            Text("Ingush foundations")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(20)
        .cardBackground()
    }
}

private struct ProfileStatsGrid: View {
    let progress: UserProgress

    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 140), spacing: 12)], spacing: 12) {
            ProfileStatCard(title: "Streak", value: progress.streakDays.formatted(), symbol: "flame.fill")
            ProfileStatCard(title: "XP", value: progress.xp.formatted(), symbol: "sparkles")
            ProfileStatCard(title: "Lessons", value: progress.lessonsCompleted.formatted(), symbol: "checkmark.seal.fill")
        }
    }
}

private struct ProfileStatCard: View {
    let title: String
    let value: String
    let symbol: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(systemName: symbol)
                .font(.title3)
                .foregroundStyle(.green)
                .accessibilityHidden(true)

            Text(value)
                .font(.title)
                .bold()

            Text(title)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(.rect(cornerRadius: 16, style: .continuous))
    }
}

private struct SettingsPlaceholderView: View {
    var body: some View {
        VStack(spacing: 0) {
            Label("Settings", systemImage: "gearshape")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(16)

            Divider()
                .padding(.leading, 16)

            Label("Course preferences", systemImage: "slider.horizontal.3")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(16)
                .foregroundStyle(.secondary)
        }
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(.rect(cornerRadius: 16, style: .continuous))
    }
}

#Preview {
    ProfileView()
}
