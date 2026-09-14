import SwiftUI

struct SettingsRowView: View {
    let title: String
    let subtitle: String
    let icon: String

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon).font(.title3).foregroundStyle(AppColors.primary)
                .frame(width: 42, height: 42).background(AppColors.mint)
                .clipShape(RoundedRectangle(cornerRadius: 14))
            VStack(alignment: .leading, spacing: 4) {
                Text(title).font(.headline).foregroundStyle(AppColors.ink)
                Text(subtitle).font(.caption).foregroundStyle(AppColors.secondaryText)
            }
            Spacer(minLength: 4)
            Image(systemName: "chevron.right").font(.caption).foregroundStyle(AppColors.primary)
        }.frame(maxWidth: .infinity, alignment: .leading).contentShape(Rectangle())
    }
}
