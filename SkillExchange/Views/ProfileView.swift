import SwiftUI

struct ProfileView: View {
    @EnvironmentObject private var appController: AppController
    @EnvironmentObject private var userController: UserController
    @EnvironmentObject private var exchangeController: ExchangeController
    @State private var confirmLogout = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    HStack {
                        Text("MY PROFILE").font(.caption2.bold()).tracking(2)
                            .foregroundStyle(AppColors.primary)
                        Spacer()
                        NavigationLink { SettingsView() } label: {
                            Image(systemName: "gearshape").font(.title2)
                                .frame(width: 48, height: 48)
                                .background(.white).clipShape(Circle())
                        }.accessibilityLabel("Open settings")
                    }
                    SectionHeading(eyebrow: "Your corner of campus", title: "Made of possibilities.")
                    VStack(spacing: 16) {
                        AvatarView(initials: userController.currentUser.initials, size: 108, isOnline: userController.localProfile.openToExchanges, useSamplePhoto: false)
                        Text(userController.currentUser.name)
                            .font(.system(.title2, design: .rounded, weight: .bold))
                        Text("Learner. Teacher. Collaborator.").font(.subheadline)
                            .foregroundStyle(AppColors.secondaryText)
                        Label(userController.localProfile.openToExchanges ? "Open to exchanging skills" : "Taking a learning break",
                              systemImage: userController.localProfile.openToExchanges ? "leaf.fill" : "pause.circle")
                            .font(.caption.bold()).padding(12).background(AppColors.mint).clipShape(Capsule())
                    }.frame(maxWidth: .infinity).campusCard()
                    HStack(spacing: 12) {
                        metric("\(exchangeController.exchanges.filter { $0.status == .ongoing }.count)", "Demo exchanges", color: AppColors.lavender)
                        metric(String(format: "%.1f", userController.currentUser.rating), "Demo rating", color: AppColors.coral)
                    }
                    VStack(alignment: .leading, spacing: 12) {
                        Text("My story").font(.title3.bold())
                        Text(userController.currentUser.about).lineSpacing(5)
                            .foregroundStyle(AppColors.secondaryText)
                    }.frame(maxWidth: .infinity, alignment: .leading).campusCard()
                    SkillsSummaryView(list: .teaching)
                    SkillsSummaryView(list: .learning)
                    Button { confirmLogout = true } label: {
                        Label("Sign out", systemImage: "rectangle.portrait.and.arrow.right")
                            .font(.headline).frame(maxWidth: .infinity).padding(18)
                            .foregroundStyle(AppColors.primary)
                    }
                }.padding(24)
            }.background(AppColors.background).toolbar(.hidden, for: .navigationBar)
                .confirmationDialog("Sign out of SkillExchange?", isPresented: $confirmLogout, titleVisibility: .visible) {
                    Button("Sign out", role: .destructive) { appController.logout() }
                    Button("Stay here", role: .cancel) {}
                }
        }
    }

    private func metric(_ value: String, _ label: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(value).font(.system(.largeTitle, design: .rounded, weight: .bold))
            Text(label).font(.caption.bold())
        }.frame(maxWidth: .infinity, alignment: .leading).padding(24)
            .background(color).clipShape(RoundedRectangle(cornerRadius: 24))
    }
}
