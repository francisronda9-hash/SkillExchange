import SwiftUI

struct MessagesView: View {
    @EnvironmentObject private var userController: UserController
    @State private var searchText = ""

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    SectionHeading(eyebrow: "Better together", title: "Your inbox.")
                    Text("Where a good exchange begins.")
                        .foregroundStyle(AppColors.secondaryText)
                    HStack {
                        Image(systemName: "magnifyingglass")
                        TextField("Find a conversation", text: $searchText)
                    }.padding(18).background(.white).clipShape(RoundedRectangle(cornerRadius: 18))
                    Text("CONVERSATION PREVIEWS").font(.caption2.bold()).tracking(2)
                        .foregroundStyle(AppColors.secondaryText)
                    ForEach(userController.filteredUsers(searchText: searchText).prefix(3)) { user in
                        HStack(alignment: .top, spacing: 14) {
                            AvatarView(initials: user.initials, size: 56, isOnline: user.isOnline)
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text(user.name).font(.headline)
                                    Spacer()
                                    Text("Preview").font(.caption2).foregroundStyle(AppColors.secondaryText)
                                }
                                Text("Let's make time to learn something new.")
                                    .font(.subheadline).foregroundStyle(AppColors.secondaryText)
                                Text(user.isOnline ? "Available now" : "Away")
                                    .font(.caption2.bold()).foregroundStyle(AppColors.primary)
                            }
                        }.campusCard()
                    }
                    Label("Live chat is planned for the functionality phase.", systemImage: "info.circle")
                        .font(.caption).foregroundStyle(AppColors.secondaryText)
                }.padding(24)
            }.background(AppColors.background).toolbar(.hidden, for: .navigationBar)
        }
    }
}
