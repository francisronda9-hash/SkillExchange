import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var appController: AppController

    var body: some View {
        if let uid = appController.userID {
            MainTabView(uid: uid).id(uid)
        } else {
            LoginView()
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AppController())
}

