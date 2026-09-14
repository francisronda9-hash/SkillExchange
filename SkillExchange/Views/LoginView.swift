import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var appController: AppController
    @State private var email = ""
    @State private var password = ""
    @State private var showPassword = false
    @State private var register = false
    @State private var notice = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 26) {
                HStack(spacing: 10) {
                    Image(systemName: "arrow.triangle.2.circlepath")
                        .font(.title2.bold()).padding(12)
                        .background(AppColors.mint).clipShape(RoundedRectangle(cornerRadius: 16))
                    Text("SkillExchange").font(.headline)
                    Spacer()
                    Text("CAMPUS").font(.caption2.bold()).tracking(2)
                }.foregroundStyle(AppColors.ink)

                VStack(alignment: .leading, spacing: 20) {
                    Text("GOOD THINGS GROW TOGETHER").font(.caption2.bold()).tracking(2)
                        .foregroundStyle(AppColors.mint)
                    Text("Your skill.\nTheir next\nbig thing.")
                        .font(.system(size: 43, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                    HStack {
                        SkillChipView(title: "Teach something", color: AppColors.mint)
                        Image(systemName: "arrow.left.arrow.right").foregroundStyle(.white)
                    }
                    SkillChipView(title: "Learn something new", color: AppColors.coral)
                }.padding(26).frame(maxWidth: .infinity, alignment: .leading)
                    .background(AppColors.ink).clipShape(RoundedRectangle(cornerRadius: 30))

                VStack(alignment: .leading, spacing: 16) {
                    Text("Welcome back.").font(.title2.bold()).foregroundStyle(AppColors.ink)
                    Text("Your next exchange starts here.").foregroundStyle(AppColors.secondaryText)
                    HStack {
                        Image(systemName: "envelope")
                        TextField("University email", text: $email)
                            .keyboardType(.emailAddress).textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                    }.padding(18).background(.white).clipShape(RoundedRectangle(cornerRadius: 16))
                    HStack {
                        Image(systemName: "lock")
                        Group {
                            if showPassword { TextField("Password", text: $password) }
                            else { SecureField("Password", text: $password) }
                        }
                        Button { showPassword.toggle() } label: {
                            Image(systemName: showPassword ? "eye.slash" : "eye")
                        }.accessibilityLabel(showPassword ? "Hide password" : "Show password")
                    }.padding(18).background(.white).clipShape(RoundedRectangle(cornerRadius: 16))
                    if let error = appController.errorText {
                        Text(error)
                            .font(.caption).foregroundStyle(.red)
                    }
                    PrimaryButton(title: appController.isBusy ? "Signing in…" : "Let's get learning") {
                        Task { await appController.login(email: email, password: password) }
                    }.disabled(appController.isBusy)
                    HStack {
                        Button("Create account") { register = true }
                        Spacer()
                        Button("Forgot password?") { notice = true }
                    }.font(.caption.bold()).tint(AppColors.primary)
                    Text("Sign in with your SkillExchange account.")
                        .font(.caption2).foregroundStyle(AppColors.secondaryText)
                }
            }.padding(24)
        }
        .background(AppColors.background.ignoresSafeArea())
        .sheet(isPresented: $register) { AccountFormView(isRegistration: true) }
        .sheet(isPresented: $notice) { AccountFormView(isRegistration: false) }
    }
}
