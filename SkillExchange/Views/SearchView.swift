import SwiftUI

struct SearchView: View {
    @EnvironmentObject private var userController: UserController
    @State private var searchText = ""
    @State private var onlineOnly = false

    private var results: [User] {
        userController.filteredUsers(searchText: searchText).filter { !onlineOnly || $0.isOnline }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    SectionHeading(eyebrow: "Discover", title: "Find your people.")
                    Text("Sample partners · Real matching is coming in the next phase.").font(.caption).foregroundStyle(AppColors.secondaryText)
                    Text("Trade what you know for what comes next.")
                        .foregroundStyle(AppColors.secondaryText)
                    HStack {
                        Image(systemName: "magnifyingglass")
                        TextField("Try UI design, Python, or a name", text: $searchText)
                            .autocorrectionDisabled()
                        if !searchText.isEmpty {
                            Button { searchText = "" } label: { Image(systemName: "xmark.circle.fill") }
                                .accessibilityLabel("Clear search")
                        }
                    }.padding(18).background(.white).clipShape(RoundedRectangle(cornerRadius: 18))
                    Toggle("Available now", isOn: $onlineOnly).tint(AppColors.primary)
                    Text("\(results.count) LEARNING PARTNERS").font(.caption2.bold()).tracking(2)
                        .foregroundStyle(AppColors.secondaryText)
                    if results.isEmpty {
                        ContentUnavailableView.search(text: searchText)
                    }
                    ForEach(results) { user in
                        NavigationLink(value: user) { UserCardView(user: user) }.buttonStyle(.plain)
                    }
                }.padding(24)
            }.background(AppColors.background)
                .navigationDestination(for: User.self) { UserProfileView(user: $0) }
                .toolbar(.hidden, for: .navigationBar)
        }
    }
}
