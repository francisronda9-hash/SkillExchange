import SwiftUI

struct SkillChipView: View {
    let title: String
    var color: Color = AppColors.mint

    var body: some View {
        Text(title).font(.subheadline.weight(.medium))
            .padding(.horizontal, 14).padding(.vertical, 9)
            .foregroundStyle(AppColors.ink)
            .background(color).clipShape(Capsule())
    }
}
