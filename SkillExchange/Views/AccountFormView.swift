import SwiftUI

struct AccountFormView: View {
    let isRegistration: Bool
    @EnvironmentObject private var appController: AppController
    @Environment(\.dismiss) private var dismiss
    @State private var email = ""
    @State private var password = ""
    @State private var confirmation = ""
    @State private var busy = false
    @State private var errorText: String?
    @State private var sent = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    SectionHeading(eyebrow: "SkillExchange", title: isRegistration ? "Start growing." : "Let's get you back.")
                    TextField("Email address", text: $email)
                        .keyboardType(.emailAddress).textContentType(.emailAddress)
                        .textInputAutocapitalization(.never).autocorrectionDisabled().campusCard()
                    if isRegistration {
                        SecureField("Password (at least 6 characters)", text: $password)
                            .textContentType(.newPassword).campusCard()
                        SecureField("Confirm password", text: $confirmation)
                            .textContentType(.newPassword).campusCard()
                        Text("After registration, set your name and skills in Profile → Settings.").font(.caption)
                    }
                    if let errorText { Text(errorText).foregroundStyle(.red) }
                    if sent {
                        Text("If an account exists for this email, check its inbox and spam folder for the reset link.")
                        Button("Done") { dismiss() }
                    } else {
                        PrimaryButton(title: busy ? "Please wait…" : (isRegistration ? "Create account" : "Send reset link")) {
                            Task {
                                busy = true
                                errorText = nil
                                defer { busy = false }
                                do {
                                    guard email.contains("@") else { throw ProfileError.message("Enter a valid email address.") }
                                    if isRegistration {
                                        guard password.count >= 6, password == confirmation else {
                                            throw ProfileError.message("Use at least 6 characters and matching passwords.")
                                        }
                                        try await appController.register(email: email, password: password)
                                        dismiss()
                                    } else {
                                        try await appController.resetPassword(email: email)
                                        sent = true
                                    }
                                } catch { errorText = error.localizedDescription }
                            }
                        }.disabled(busy)
                    }
                }.padding(24)
            }.background(AppColors.background)
                .navigationTitle(isRegistration ? "Create account" : "Reset password")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar { ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() }.disabled(busy) } }
                .interactiveDismissDisabled(busy)
        }
    }
}
