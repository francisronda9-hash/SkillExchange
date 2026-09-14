import Foundation

struct Exchange: Identifiable {
    let id = UUID()
    let user: User
    let status: ExchangeStatus
    let duration: String
    var teaching: String = ""
    var learning: String = ""
    var message: String = ""
}

enum ExchangeStatus: String {
    case ongoing = "Ongoing"
    case received = "Received"
    case sent = "Sent"
    case completed = "Completed"
}
