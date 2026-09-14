import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var appController: AppController
    @EnvironmentObject private var userController: UserController
    @EnvironmentObject private var exchangeController: ExchangeController

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 26) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("YOUR CAMPUS, CONNECTED").font(.caption2.bold()).tracking(2)
                                .foregroundStyle(AppColors.primary)
                            Text("Hey, \(userController.firstName).").font(.title2.bold()).foregroundStyle(AppColors.ink)
                        }
                        Spacer()
                        Button { appController.selectedTab = 4 } label: {
                            AvatarView(initials: userController.currentUser.initials, size: 48, useSamplePhoto: false)
                        }.accessibilityLabel("Open my profile")
                    }
                    VStack(alignment: .leading, spacing: 20) {
                        Text("A little teaching.\nA lot of possibility.")
                            .font(.system(.largeTitle, design: .rounded, weight: .bold))
                        Text("Find someone who knows what you want to learn.")
                            .font(.subheadline).foregroundStyle(AppColors.mint)
                        Button { appController.selectedTab = 1 } label: {
                            HStack {
                                Text("Find a learning partner").fontWeight(.semibold)
                                Spacer()
                                Image(systemName: "arrow.up.right")
                            }.padding(16).foregroundStyle(AppColors.ink)
                                .background(AppColors.mint).clipShape(RoundedRectangle(cornerRadius: 16))
                        }.buttonStyle(.plain)
                    }.padding(24).foregroundStyle(.white)
                        .background(AppColors.ink).clipShape(RoundedRectangle(cornerRadius: 28))
                    Button { appController.selectedTab = 3 } label: {
                        HStack(spacing: 16) {
                            Image(systemName: "arrow.triangle.2.circlepath").font(.title2)
                                .padding(14).background(.white.opacity(0.6)).clipShape(Circle())
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Keep the learning going").font(.headline)
                                Text("\(exchangeController.exchanges.filter { $0.status == .ongoing }.count) demo exchanges")
                                    .font(.subheadline)
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                        }.padding(18).foregroundStyle(AppColors.primary)
                            .background(AppColors.mint).clipShape(RoundedRectangle(cornerRadius: 24))
                    }.buttonStyle(.plain)
                    SkillsSummaryView(list: .teaching)
                    SkillsSummaryView(list: .learning)
                    HStack {
                        Text("Explore a new skill").font(.title3.bold())
                        Spacer()
                        Button("See all") { appController.selectedTab = 1 }.font(.caption.bold())
                    }
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                        category("Development", icon: "curlybraces", color: AppColors.lavender)
                        category("Creative skills", icon: "scribble.variable", color: AppColors.coral)
                    }
                    HStack {
                        Text("Sample learning partners").font(.title3.bold())
                        Spacer()
                        Image(systemName: "sparkles").foregroundStyle(AppColors.primary)
                    }
                    ForEach(userController.users.prefix(3)) { user in
                        NavigationLink(value: user) { UserCardView(user: user) }.buttonStyle(.plain)
                    }
                }.padding(24)
            }
            .background(AppColors.background)
            .navigationDestination(for: User.self) { UserProfileView(user: $0) }
            .toolbar(.hidden, for: .navigationBar)
        }
    }

    private func category(_ name: String, icon: String, color: Color) -> some View {
        Button { appController.selectedTab = 1 } label: {
            VStack(alignment: .leading, spacing: 20) {
                Image(systemName: icon).font(.title)
                Text(name).font(.subheadline.bold())
                Image(systemName: "arrow.up.right")
            }.frame(maxWidth: .infinity, alignment: .leading).padding(20)
                .foregroundStyle(AppColors.ink).background(color)
                .clipShape(RoundedRectangle(cornerRadius: 24))
        }.buttonStyle(.plain)
    }
}
