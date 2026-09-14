import SwiftUI

struct MySkillsView: View {
    @EnvironmentObject private var userController: UserController
    @State private var list: SkillList
    @State private var editor: SkillEditorRequest?
    @State private var pendingDelete: Skill?
    @State private var confirmDelete = false
    @State private var errorText: String?

    init(initialList: SkillList = .teaching) {
        _list = State(initialValue: initialList)
    }

    private var skills: [Skill] { userController.localProfile.skills(in: list) }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                SectionHeading(eyebrow: "Give and grow", title: "My skills.")
                Picker("Skill list", selection: $list) {
                    ForEach(SkillList.allCases) { Text($0.shortTitle).tag($0) }
                }.pickerStyle(.segmented)
                Text(list == .teaching ? "Share what you already know." : "Make space for something new.")
                    .foregroundStyle(AppColors.secondaryText)
                if skills.isEmpty {
                    ContentUnavailableView("Start with one skill", systemImage: "leaf",
                        description: Text("Tap Add skill below to build this list."))
                }
                ForEach(skills) { skill in
                    HStack(spacing: 16) {
                        Button { editor = SkillEditorRequest(list: list, skill: skill) } label: {
                            HStack(spacing: 12) {
                                Image(systemName: skill.icon).font(.title2)
                                    .frame(width: 46, height: 46)
                                    .background(list == .teaching ? AppColors.mint : AppColors.lavender)
                                    .clipShape(RoundedRectangle(cornerRadius: 15))
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(skill.name).font(.headline)
                                    Text(list == .teaching ? skill.level : "Goal: " + skill.level)
                                        .font(.caption).foregroundStyle(AppColors.secondaryText)
                                }
                                Spacer(minLength: 0)
                                Image(systemName: "pencil").font(.caption)
                            }.contentShape(Rectangle())
                        }.buttonStyle(.plain).accessibilityLabel("Edit " + skill.name)
                        Button {
                            pendingDelete = skill
                            confirmDelete = true
                        } label: {
                            Image(systemName: "trash").foregroundStyle(.red).frame(width: 44, height: 44)
                        }.buttonStyle(.plain).accessibilityLabel("Delete " + skill.name)
                    }.campusCard()
                }
                PrimaryButton(title: "Add skill") {
                    editor = SkillEditorRequest(list: list, skill: nil)
                }
                if let errorText {
                    Text(errorText).foregroundStyle(.red).font(.caption)
                }
            }.padding(24)
        }.background(AppColors.background)
            .navigationTitle("Manage skills").navigationBarTitleDisplayMode(.inline)
            .toolbar(.visible, for: .navigationBar)
            .sheet(item: $editor) { SkillEditorView(list: $0.list, skill: $0.skill) }
            .alert("Remove this skill?", isPresented: $confirmDelete) {
                Button("Remove", role: .destructive) {
                    if let pendingDelete {
                        let selectedList = list
                        Task {
                            do { try await userController.deleteSkill(pendingDelete.id, from: selectedList) }
                            catch { errorText = error.localizedDescription }
                        }
                    }
                    pendingDelete = nil
                }
                Button("Keep skill", role: .cancel) { pendingDelete = nil }
            } message: {
                Text("Remove \(pendingDelete?.name ?? "this skill") from \(list.title.lowercased())?")
            }
    }
}
