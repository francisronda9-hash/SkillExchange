import SwiftUI

struct ProposeExchangeView: View {
    let user: User
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var exchangeController: ExchangeController
    @EnvironmentObject private var userController: UserController
    @State private var teaching = ""
    @State private var duration = "1 Week"
    @State private var message = ""
    @State private var sent = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    if sent {
                        VStack(spacing: 22) {
                            Image(systemName: "checkmark.seal.fill").font(.system(size: 76))
                                .foregroundStyle(AppColors.primary)
                            Text("A new possibility.").font(.system(.largeTitle, design: .rounded, weight: .bold))
                            Text("Your proposal is in the Sent tab. This preview saves it for the current session only.")
                                .multilineTextAlignment(.center).foregroundStyle(AppColors.secondaryText)
                            PrimaryButton(title: "Back to exploring") { dismiss() }
                        }.padding(.vertical, 50)
                    } else {
                        SectionHeading(eyebrow: "Start something good", title: "Make it a fair trade.")
                        HStack(spacing: 14) {
                            AvatarView(initials: user.initials, size: 52)
                            VStack(alignment: .leading, spacing: 4) {
                                Text("An exchange with").font(.caption).foregroundStyle(AppColors.secondaryText)
                                Text(user.name).font(.headline)
                            }
                        }.frame(maxWidth: .infinity, alignment: .leading).campusCard()

                        VStack(alignment: .leading, spacing: 18) {
                            Label("Your side of the exchange", systemImage: "arrow.up.right").font(.headline)
                            if userController.localProfile.teaching.isEmpty {
                                Text("Add a skill you can teach before sending a proposal.")
                                    .font(.subheadline).foregroundStyle(AppColors.secondaryText)
                            } else {
                                Picker("I'll teach", selection: $teaching) {
                                    if teaching.isEmpty { Text("Choose a skill").tag("") }
                                    ForEach(userController.localProfile.teaching) { skill in
                                        Text(skill.name).tag(skill.name)
                                    }
                                }.tint(AppColors.primary)
                            }
                            NavigationLink("Manage my teaching skills") { MySkillsView(initialList: .teaching) }
                                .font(.caption.bold()).tint(AppColors.primary)
                            Divider()
                            HStack {
                                Text("I'll learn").foregroundStyle(AppColors.secondaryText)
                                Spacer()
                                Text(user.canTeach).fontWeight(.semibold)
                            }
                        }.campusCard()
                        VStack(alignment: .leading, spacing: 14) {
                            Label("Make time to grow", systemImage: "calendar").font(.headline)
                            Picker("Duration", selection: $duration) {
                                Text("1 Week").tag("1 Week")
                                Text("2 Weeks").tag("2 Weeks")
                                Text("1 Month").tag("1 Month")
                            }.tint(AppColors.primary)
                        }.campusCard()
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Say hello").font(.headline)
                            Text("Share your goals or a good time to meet.").font(.caption)
                                .foregroundStyle(AppColors.secondaryText)
                            TextEditor(text: $message).frame(minHeight: 100)
                                .accessibilityLabel("Optional message")
                        }.campusCard()
                        PrimaryButton(title: "Send proposal") {
                            guard userController.localProfile.teaching.contains(where: { $0.name == teaching }) else { return }
                            exchangeController.submitRequest(to: user, teaching: teaching, learning: user.canTeach, duration: duration, message: message)
                            sent = true
                        }
                        .disabled(!userController.localProfile.teaching.contains(where: { $0.name == teaching }))
                        .opacity(teaching.isEmpty ? 0.5 : 1)
                        Text("Local preview — no notification is sent to another person.")
                            .font(.caption).foregroundStyle(AppColors.secondaryText)
                    }
                }.padding(24)
            }.background(AppColors.background)
                .onAppear { syncTeachingSelection() }
                .onChange(of: userController.localProfile.teaching) { _, _ in syncTeachingSelection() }
                .navigationTitle("New exchange").navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Close") { dismiss() }.tint(AppColors.primary)
                    }
                }
        }
    }

    private func syncTeachingSelection() {
        if !userController.localProfile.teaching.contains(where: { $0.name == teaching }) {
            teaching = userController.localProfile.teaching.first?.name ?? ""
        }
    }
}
