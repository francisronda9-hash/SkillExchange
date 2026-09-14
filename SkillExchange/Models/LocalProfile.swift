import Foundation

struct LocalProfile: Codable {
    var name = "New member"
    var about = ""
    var openToExchanges = true
    var teaching: [Skill] = []
    var learning: [Skill] = []

    func skills(in list: SkillList) -> [Skill] {
        list == .teaching ? teaching : learning
    }
}
