import SwiftUI

struct EditProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var userController: UserController
    @State private var name: String
    @State private var about: String
    @State private var errorText: String?

    init(profile: LocalProfile) {
        _name = State(initialValue: profile.name)
        _about = State(initialValue: profile.about)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                SectionHeading(eyebrow: "Tell your story", title: "A little about you.")
                VStack(alignment: .leading, spacing: 12) {
                    Text("Display name").font(.headline)
                    TextField("Your name", text: $name)
                        .textInputAutocapitalization(.words).textContentType(.name)
                        .padding(14).background(AppColors.background)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }.campusCard()
                VStack(alignment: .leading, spacing: 12) {
                    Text("Introduction").font(.headline)
                    TextEditor(text: $about).frame(minHeight: 150)
                        .accessibilityLabel("Introduction")
                    Text("\(about.count)/500 characters").font(.caption)
                        .foregroundStyle(AppColors.secondaryText)
                }.campusCard()
                if let errorText { Text(errorText).foregroundStyle(.red).font(.caption) }
                PrimaryButton(title: "Save profile") {
                    Task {
                        do {
                            try await userController.updateProfile(name: name, about: about)
                            dismiss()
                        } catch { errorText = error.localizedDescription }
                    }
                }
            }.padding(24)
        }.background(AppColors.background)
            .navigationTitle("Edit profile").navigationBarTitleDisplayMode(.inline)
            .toolbar(.visible, for: .navigationBar)
    }
}
