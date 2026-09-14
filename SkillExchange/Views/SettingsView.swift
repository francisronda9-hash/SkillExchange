import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var userController: UserController
    @EnvironmentObject private var appController: AppController
    @State private var confirmLogout = false
    @State private var errorText: String?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                SectionHeading(eyebrow: "Make yourself at home", title: "Settings.")
                VStack(alignment: .leading, spacing: 18) {
                    Text("Your profile").font(.title3.bold())
                    NavigationLink {
                        EditProfileView(profile: userController.localProfile)
                    } label: {
                        SettingsRowView(title: "Edit profile", subtitle: "Name and introduction", icon: "person.crop.circle")
                    }.buttonStyle(.plain)
                    Divider()
                    NavigationLink { MySkillsView() } label: {
                        SettingsRowView(title: "Manage my skills", subtitle: "What you teach and want to learn", icon: "square.stack.3d.up")
                    }.buttonStyle(.plain)
                }.campusCard()
                VStack(alignment: .leading, spacing: 14) {
                    Text("Availability").font(.title3.bold())
                    Toggle("Open to exchanges", isOn: Binding(
                        get: { userController.localProfile.openToExchanges },
                        set: { value in
                            Task {
                                do { try await userController.setOpenToExchanges(value) }
                                catch { errorText = error.localizedDescription }
                            }
                        }
                    )).tint(AppColors.primary)
                    Text("Updates the availability badge on your saved profile.")
                        .font(.caption).foregroundStyle(AppColors.secondaryText)
                }.campusCard()
                NavigationLink { AboutAppView() } label: {
                    SettingsRowView(title: "About SkillExchange", subtitle: "How the campus exchange works", icon: "info.circle")
                        .campusCard()
                }.buttonStyle(.plain)
                if let errorText { Text(errorText).foregroundStyle(.red).font(.caption) }
                Button { confirmLogout = true } label: {
                    Label("Sign out", systemImage: "rectangle.portrait.and.arrow.right")
                        .font(.headline).frame(maxWidth: .infinity).padding(18)
                }.foregroundStyle(AppColors.primary)
                Text("Your profile and skills are saved to your account.")
                    .font(.caption).foregroundStyle(AppColors.secondaryText)
            }.padding(24)
        }.background(AppColors.background)
            .navigationTitle("Settings").navigationBarTitleDisplayMode(.inline)
            .toolbar(.visible, for: .navigationBar)
            .confirmationDialog("Sign out of SkillExchange?", isPresented: $confirmLogout, titleVisibility: .visible) {
                Button("Sign out", role: .destructive) { appController.logout() }
                Button("Stay here", role: .cancel) {}
            }
    }
}
