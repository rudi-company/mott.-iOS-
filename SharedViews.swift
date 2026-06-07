import SwiftUI

struct CardBackground: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(.regularMaterial)
            .clipShape(.rect(cornerRadius: 16, style: .continuous))
    }
}

struct SettingsToolbarModifier: ViewModifier {
    @Environment(AppSettings.self) private var appSettings
    @State private var isShowingSettings = false

    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Settings", systemImage: "gearshape") {
                        isShowingSettings = true
                    }
                }
            }
            .sheet(isPresented: $isShowingSettings) {
                SettingsView(settings: appSettings)
            }
    }
}

extension View {
    func cardBackground() -> some View {
        modifier(CardBackground())
    }

    func settingsToolbar() -> some View {
        modifier(SettingsToolbarModifier())
    }
}

struct ProgressBadge: View {
    let progress: Double

    var body: some View {
        Gauge(value: progress) {
            Text("Progress")
        }
        .gaugeStyle(.accessoryCircularCapacity)
        .tint(.green)
        .accessibilityValue(progress.formatted(.percent.precision(.fractionLength(0))))
    }
}
