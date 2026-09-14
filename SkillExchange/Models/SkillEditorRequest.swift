import Foundation

struct SkillEditorRequest: Identifiable {
    let id = UUID()
    let list: SkillList
    let skill: Skill?
}
