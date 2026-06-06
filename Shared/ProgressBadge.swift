import SwiftUI

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
