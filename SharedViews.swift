import SwiftUI

struct CardBackground: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(.regularMaterial)
            .clipShape(.rect(cornerRadius: 16, style: .continuous))
    }
}

extension View {
    func cardBackground() -> some View {
        modifier(CardBackground())
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
        .accessibilityValue(progress, format: .percent.precision(.fractionLength(0)))
    }
}
