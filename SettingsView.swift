import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var settings: AppSettings

    var body: some View {
        NavigationStack {
            List {
                Section("Course") {
                    Picker("Base Language", selection: $settings.baseLanguage) {
                        ForEach(BaseLanguage.allCases) { language in
                            Text(language.rawValue)
                                .tag(language)
                        }
                    }

                    LabeledContent("Learning", value: "Ingush")
                }

                Section("Daily Goal") {
                    Picker("Goal", selection: $settings.dailyGoal) {
                        ForEach(AppSettings.DailyGoal.allCases) { goal in
                            Text(goal.rawValue)
                                .tag(goal)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                Section("Audio") {
                    Toggle("Audio", systemImage: "speaker.wave.2", isOn: $settings.isAudioEnabled)
                    Toggle("Pronunciation Practice", systemImage: "waveform.and.mic", isOn: $settings.isPronunciationPracticeEnabled)
                }

                Section("Content Review") {
                    Toggle("Native-Speaker Review", systemImage: "checkmark.seal", isOn: $settings.requiresNativeSpeakerReview)

                    Text("Audio and generated practice content should be reviewed before release.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }

                Section("About") {
                    LabeledContent("Course", value: "Ingush Foundations")
                    LabeledContent("Status", value: "Draft")
                    LabeledContent("Version", value: "0.1")
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done", action: dismiss.callAsFunction)
                }
            }
        }
    }
}

#Preview {
    SettingsView(settings: AppSettings())
}
