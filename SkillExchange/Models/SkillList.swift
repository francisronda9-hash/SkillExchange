import Foundation

enum SkillList: String, CaseIterable, Identifiable {
    case teaching
    case learning

    var id: String { rawValue }
    var title: String {
        self == .teaching ? "Skills I can teach" : "Skills I want to learn"
    }
    var shortTitle: String { self == .teaching ? "Can teach" : "Want to learn" }
    var levels: [String] {
        ["Beginner", "Intermediate", "Advanced"]
    }
}
