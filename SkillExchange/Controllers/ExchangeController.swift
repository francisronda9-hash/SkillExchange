import SwiftUI
import Combine

final class ExchangeController: ObservableObject {
    @Published var exchanges: [Exchange]
    @Published var requestWasSent = false

    init() {
        let users = UserController().users
        exchanges = [
            Exchange(user: users[0], status: .ongoing, duration: "2 Weeks"),
            Exchange(user: users[1], status: .ongoing, duration: "1 Week"),
            Exchange(user: users[2], status: .ongoing, duration: "2 Weeks"),
            Exchange(user: users[3], status: .received, duration: "2 Weeks"),
            Exchange(user: users[4], status: .received, duration: "1 Week")
        ]
    }

    func submitRequest(to user: User, teaching: String, learning: String, duration: String, message: String = "") {
        exchanges.append(Exchange(user: user, status: .sent, duration: duration, teaching: teaching, learning: learning, message: message))
        requestWasSent = true
    }
}
