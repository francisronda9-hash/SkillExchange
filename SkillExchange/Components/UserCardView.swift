import SwiftUI

struct UserCardView: View {
    let user: User

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(spacing: 12) {
                AvatarView(initials: user.initials, size: 54, isOnline: user.isOnline)
                VStack(alignment: .leading, spacing: 4) {
                    Text(user.name).font(.headline).foregroundStyle(AppColors.ink)
                    Text("Campus learning partner").font(.caption).foregroundStyle(AppColors.secondaryText)
                }
                Spacer(minLength: 4)
                Label(String(format: "%.1f", user.rating), systemImage: "star.fill")
                    .font(.caption.bold()).foregroundStyle(AppColors.primary)
            }
            HStack(alignment: .top, spacing: 16) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("CAN TEACH").font(.caption2.bold()).foregroundStyle(AppColors.primary)
                    Text(user.canTeach).font(.subheadline.bold())
                }.frame(maxWidth: .infinity, alignment: .leading)
                Rectangle().fill(AppColors.mint).frame(width: 1, height: 38)
                VStack(alignment: .leading, spacing: 6) {
                    Text("WANTS TO LEARN").font(.caption2.bold()).foregroundStyle(AppColors.secondaryText)
                    Text(user.wantsToLearn).font(.subheadline.bold())
                }.frame(maxWidth: .infinity, alignment: .leading)
            }.foregroundStyle(AppColors.ink)
            HStack {
                Text("Meet your next collaborator").font(.caption)
                Spacer()
                Image(systemName: "arrow.up.right")
            }.foregroundStyle(AppColors.primary)
        }
        .campusCard()
    }
}
