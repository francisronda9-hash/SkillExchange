import SwiftUI

struct MainTabView: View {
    @EnvironmentObject private var appController: AppController
    @StateObject private var userController: UserController
    @StateObject private var exchangeController = ExchangeController()

    init(uid: String) {
        _userController = StateObject(wrappedValue: UserController(uid: uid))
    }

    var body: some View {
        Group {
            if userController.isReady { tabs }
            else if let error = userController.loadError {
                VStack(spacing: 18) {
                    Text("Couldn't load your profile").font(.headline)
                    Text(error).font(.subheadline)
                    Button("Retry") { Task { await userController.load() } }
                    Button("Sign out") { appController.logout() }
                }.padding(24)
            } else { ProgressView("Loading your profile…") }
        }
        .task { await userController.load() }
        .alert("Account error", isPresented: Binding(get: { appController.errorText != nil }, set: { if !$0 { appController.errorText = nil } })) {
            Button("OK") { appController.errorText = nil }
        } message: { Text(appController.errorText ?? "") }
    }

    private var tabs: some View {
        TabView(selection: $appController.selectedTab) {
            HomeView().tabItem { Label("Home", systemImage: "square.grid.2x2.fill") }.tag(0)
            SearchView().tabItem { Label("Discover", systemImage: "sparkle.magnifyingglass") }.tag(1)
            MyExchangesView().tabItem { Label("Exchanges", systemImage: "arrow.left.arrow.right") }.tag(3)
            MessagesView().tabItem { Label("Inbox", systemImage: "bubble.left.and.bubble.right") }.tag(2)
            ProfileView().tabItem { Label("Profile", systemImage: "person.crop.circle") }.tag(4)
        }
        .disabled(userController.isSaving)
        .overlay { if userController.isSaving { ProgressView("Saving…").padding().background(.regularMaterial).clipShape(RoundedRectangle(cornerRadius: 16)) } }
        .tint(AppColors.primary)
        .environmentObject(userController)
        .environmentObject(exchangeController)
    }
}
