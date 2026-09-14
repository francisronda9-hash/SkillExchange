import SwiftUI
import Combine
import FirebaseCore
import FirebaseAuth

@MainActor
final class AppController: ObservableObject {
    @Published private(set) var userID: String?
    @Published private(set) var isBusy = false
    @Published var errorText: String?
    private var listener: AuthStateDidChangeListenerHandle?
    var isLoggedIn: Bool { userID != nil }
    @Published var selectedTab = 0

    init() {
        if FirebaseApp.app() == nil { FirebaseApp.configure() }
        userID = Auth.auth().currentUser?.uid
        listener = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            Task { @MainActor [weak self] in self?.userID = user?.uid }
        }
    }

    func login(email: String, password: String) async {
        guard !isBusy else { return }
        isBusy = true
        errorText = nil
        defer { isBusy = false }
        do {
            _ = try await Auth.auth().signIn(withEmail: email.trimmingCharacters(in: .whitespacesAndNewlines), password: password)
        } catch { errorText = error.localizedDescription }
    }

    func register(email: String, password: String) async throws {
        guard !isBusy else { throw ProfileError.message("Please wait for the current sign-in request.") }
        isBusy = true
        defer { isBusy = false }
        _ = try await Auth.auth().createUser(withEmail: email.trimmingCharacters(in: .whitespacesAndNewlines), password: password)
    }

    func resetPassword(email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email.trimmingCharacters(in: .whitespacesAndNewlines))
    }

    func logout() {
        do {
            try Auth.auth().signOut()
            userID = nil
            selectedTab = 0
        } catch { errorText = error.localizedDescription }
    }
}
