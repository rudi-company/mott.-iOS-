import Foundation
import Observation

enum BaseLanguage: String, CaseIterable, Identifiable, Hashable {
    case english = "English"
    case russian = "Russian"

    var id: String { rawValue }
}

@MainActor
@Observable
final class AppSettings {
    var baseLanguage: BaseLanguage = .english
    var dailyGoal: DailyGoal = .tenMinutes
    var isAudioEnabled = true
    var isPronunciationPracticeEnabled = true
    var requiresNativeSpeakerReview = true

    enum DailyGoal: String, CaseIterable, Identifiable {
        case fiveMinutes = "5 min"
        case tenMinutes = "10 min"
        case fifteenMinutes = "15 min"

        var id: String { rawValue }
    }
}
