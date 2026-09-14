import SwiftUI

struct MyExchangesView: View {
    @EnvironmentObject private var exchangeController: ExchangeController
    @State private var selectedStatus: ExchangeStatus = .ongoing

    private var filtered: [Exchange] {
        exchangeController.exchanges.filter { $0.status == selectedStatus }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    SectionHeading(eyebrow: "Give a little. Gain a lot.", title: "Your exchanges.")
                    Text("Demo exchanges · Proposals are not delivered to other accounts yet.").font(.caption).foregroundStyle(AppColors.secondaryText)
                    Text("Small commitments. Meaningful progress.")
                        .foregroundStyle(AppColors.secondaryText)
                    Picker("Exchange status", selection: $selectedStatus) {
                        Text("Ongoing").tag(ExchangeStatus.ongoing)
                        Text("Received").tag(ExchangeStatus.received)
                        Text("Sent").tag(ExchangeStatus.sent)
                    }.pickerStyle(.segmented)
                    if filtered.isEmpty {
                        ContentUnavailableView("Room for something new", systemImage: "leaf",
                            description: Text("Your \(selectedStatus.rawValue.lowercased()) exchanges will appear here."))
                    }
                    ForEach(filtered) { exchange in
                        VStack(alignment: .leading, spacing: 20) {
                            HStack {
                                AvatarView(initials: exchange.user.initials, size: 48)
                                Text(exchange.user.name).font(.headline)
                                Spacer()
                                Text(exchange.status.rawValue).font(.caption.bold())
                                    .padding(9).background(AppColors.mint).clipShape(Capsule())
                            }
                            HStack(alignment: .top) {
                                VStack(alignment: .leading, spacing: 6) {
                                    Text("YOU TEACH").font(.caption2.bold()).foregroundStyle(AppColors.secondaryText)
                                    Text(exchange.teaching.isEmpty ? exchange.user.wantsToLearn : exchange.teaching).font(.headline)
                                }.frame(maxWidth: .infinity, alignment: .leading)
                                Image(systemName: "arrow.left.arrow.right").foregroundStyle(AppColors.primary).padding(6)
                                VStack(alignment: .leading, spacing: 6) {
                                    Text("YOU LEARN").font(.caption2.bold()).foregroundStyle(AppColors.secondaryText)
                                    Text(exchange.learning.isEmpty ? exchange.user.canTeach : exchange.learning).font(.headline)
                                }.frame(maxWidth: .infinity, alignment: .leading)
                            }
                            Divider()
                            Label(exchange.duration, systemImage: "calendar")
                                .font(.caption).foregroundStyle(AppColors.secondaryText)
                            if !exchange.message.isEmpty {
                                Text(exchange.message).font(.subheadline)
                                    .foregroundStyle(AppColors.secondaryText)
                            }
                        }.campusCard()
                    }
                }.padding(24)
            }.background(AppColors.background).toolbar(.hidden, for: .navigationBar)
        }
    }
}
