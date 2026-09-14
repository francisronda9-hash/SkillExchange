import SwiftUI

struct SkillsSummaryView: View {
    let list: SkillList
    @EnvironmentObject private var userController: UserController
    @State private var showAdd = false

    private var skills: [Skill] { userController.localProfile.skills(in: list) }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top) {
                Text(list.title).font(.headline)
                Spacer(minLength: 8)
                NavigationLink { MySkillsView(initialList: list) } label: {
                    Text("Manage").font(.caption.bold())
                }
            }
            if skills.isEmpty {
                Text(list == .teaching ? "What could you help someone learn?" : "What would you like to learn next?")
                    .font(.subheadline).foregroundStyle(AppColors.secondaryText)
            } else {
                ForEach(skills.prefix(3)) { skill in
                    HStack(spacing: 12) {
                        Image(systemName: skill.icon).frame(width: 36, height: 36)
                            .background(list == .teaching ? AppColors.mint : AppColors.lavender)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        VStack(alignment: .leading, spacing: 3) {
                            Text(skill.name).font(.subheadline.bold())
                            Text(list == .teaching ? skill.level : "Goal: " + skill.level)
                                .font(.caption).foregroundStyle(AppColors.secondaryText)
                        }
                    }
                }
                if skills.count > 3 {
                    Text("+\(skills.count - 3) more").font(.caption).foregroundStyle(AppColors.secondaryText)
                }
            }
            Button { showAdd = true } label: {
                Label("Add skill", systemImage: "plus")
                    .font(.subheadline.bold()).frame(maxWidth: .infinity).padding(12)
                    .background(list == .teaching ? AppColors.mint : AppColors.lavender)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }.buttonStyle(.plain).foregroundStyle(AppColors.primary)
        }.frame(maxWidth: .infinity, alignment: .leading).campusCard()
            .sheet(isPresented: $showAdd) { SkillEditorView(list: list) }
    }
}
