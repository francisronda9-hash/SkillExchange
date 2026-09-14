import Foundation

struct User: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let initials: String
    let wantsToLearn: String
    let canTeach: String
    let rating: Double
    let isOnline: Bool
    let about: String
}
