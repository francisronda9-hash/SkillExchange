import Foundation

struct Skill: Identifiable, Hashable, Codable {
    var id = UUID()
    let name: String
    let icon: String
    let level: String
}
