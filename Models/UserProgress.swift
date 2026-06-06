import Foundation

struct UserProgress: Hashable {
    let streakDays: Int
    let xp: Int
    let lessonsCompleted: Int
    let dailyGoalProgress: Double
    let dailyGoalText: String
}
