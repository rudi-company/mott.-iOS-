import Foundation

/// A CEFR-inspired course level containing ordered units.
struct CourseLevel: Identifiable, Codable, Hashable {
    let id: String
    let title: String
    let subtitle: String
    let units: [CourseUnit]
}

extension CourseLevel {
    /// The level identifiers currently planned for Ingush Foundations.
    enum Identifier: String, CaseIterable, Codable, Hashable {
        case a0 = "A0"
        case a1 = "A1"
        case a2 = "A2"
        case b1 = "B1"
        case b2 = "B2"
    }
}
