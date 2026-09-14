import SwiftUI

struct SkillEditorView: View {
    let list: SkillList
    let skill: Skill?
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var userController: UserController
    @State private var name: String
    @State private var level: String
    @State private var icon: String
    @State private var errorText: String?

    private let icons = [
        ("curlybraces", "Code"), ("paintpalette", "Design"), ("video", "Video"),
        ("book", "Study"), ("music.note", "Music"), ("globe", "Language"),
        ("desktopcomputer", "Technology"), ("sportscourt", "Sports")
    ]

    init(list: SkillList, skill: Skill? = nil) {
        self.list = list
        self.skill = skill
        _name = State(initialValue: skill?.name ?? "")
        _level = State(initialValue: skill?.level ?? "Beginner")
        _icon = State(initialValue: skill?.icon ?? "book")
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    SectionHeading(eyebrow: list.shortTitle, title: skill == nil ? "Room to grow." : "Refine your skill.")
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Skill name").font(.headline)
                        TextField("For example, SwiftUI or photography", text: $name)
                            .textInputAutocapitalization(.words)
                            .padding(14).background(AppColors.background)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        Text("2–50 characters").font(.caption).foregroundStyle(AppColors.secondaryText)
                    }.campusCard()
                    VStack(alignment: .leading, spacing: 12) {
                        Text(list == .teaching ? "Your current level" : "Level you want to reach").font(.headline)
                        Picker("Level", selection: $level) {
                            ForEach(list.levels, id: \.self) { Text($0).tag($0) }
                        }.pickerStyle(.menu).tint(AppColors.primary)
                    }.frame(maxWidth: .infinity, alignment: .leading).campusCard()
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Choose an icon").font(.headline)
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 75))], spacing: 12) {
                            ForEach(icons, id: \.0) { item in
                                Button { icon = item.0 } label: {
                                    VStack(spacing: 8) {
                                        Image(systemName: item.0).font(.title2)
                                        Text(item.1).font(.caption2)
                                    }.frame(maxWidth: .infinity).padding(.vertical, 14)
                                        .foregroundStyle(AppColors.ink)
                                        .background(icon == item.0 ? AppColors.mint : AppColors.background)
                                        .clipShape(RoundedRectangle(cornerRadius: 14))
                                        .overlay(RoundedRectangle(cornerRadius: 14)
                                            .stroke(icon == item.0 ? AppColors.primary : Color.clear, lineWidth: 2))
                                }.buttonStyle(.plain)
                                    .accessibilityAddTraits(icon == item.0 ? .isSelected : [])
                            }
                        }
                    }.campusCard()
                    if let errorText {
                        Text(errorText).font(.subheadline).foregroundStyle(.red)
                    }
                    PrimaryButton(title: skill == nil ? "Add skill" : "Save changes") {
                        Task {
                            do {
                                try await userController.saveSkill(id: skill?.id, name: name, icon: icon, level: level, in: list)
                                dismiss()
                            } catch { errorText = error.localizedDescription }
                        }
                    }
                }.padding(24)
            }.disabled(userController.isSaving)
                .interactiveDismissDisabled(userController.isSaving)
                .background(AppColors.background)
                .navigationTitle(skill == nil ? "Add skill" : "Edit skill")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Cancel") { dismiss() }.tint(AppColors.primary).disabled(userController.isSaving)
                    }
                }
        }
    }
}
