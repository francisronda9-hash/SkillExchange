import SwiftUI

struct UserProfileView: View {
    let user: User
    @State private var showProposal = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                HStack(alignment: .top, spacing: 20) {
                    AvatarView(initials: user.initials, size: 104, isOnline: user.isOnline)
                    VStack(alignment: .leading, spacing: 10) {
                        Text("MEET YOUR PARTNER").font(.caption2.bold()).tracking(1)
                        Text(user.name).font(.system(.title, design: .rounded, weight: .bold))
                        Label(String(format: "%.1f community rating", user.rating), systemImage: "star.fill")
                            .font(.caption)
                    }
                }.padding(24).frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(.white).background(AppColors.ink)
                    .clipShape(RoundedRectangle(cornerRadius: 28))

                VStack(alignment: .leading, spacing: 12) {
                    Text("A little about me").font(.title3.bold())
                    Text(user.about).lineSpacing(5).foregroundStyle(AppColors.secondaryText)
                }.campusCard()
                VStack(alignment: .leading, spacing: 18) {
                    Label("What we could exchange", systemImage: "arrow.left.arrow.right")
                        .font(.headline)
                    VStack(alignment: .leading, spacing: 8) {
                        Text("I CAN HELP YOU WITH").font(.caption2.bold()).tracking(1)
                        SkillChipView(title: user.canTeach)
                    }
                    Divider()
                    VStack(alignment: .leading, spacing: 8) {
                        Text("I'D LOVE TO LEARN").font(.caption2.bold()).tracking(1)
                        SkillChipView(title: user.wantsToLearn, color: AppColors.lavender)
                    }
                }.frame(maxWidth: .infinity, alignment: .leading).campusCard()
                Text("The best exchanges start with a conversation and a shared goal.")
                    .font(.subheadline).foregroundStyle(AppColors.secondaryText).padding(.horizontal, 4)
            }.padding(24)
        }
        .background(AppColors.background)
        .navigationTitle("Learning partner").navigationBarTitleDisplayMode(.inline)
        .safeAreaInset(edge: .bottom) {
            PrimaryButton(title: "Propose an exchange") { showProposal = true }
                .padding(20).background(AppColors.background)
        }
        .sheet(isPresented: $showProposal) { ProposeExchangeView(user: user) }
    }
}
