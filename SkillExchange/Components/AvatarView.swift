import SwiftUI

struct AvatarView: View {
    let initials: String
    var size: CGFloat = 54
    var isOnline = false
    var useSamplePhoto = true

    private var asset: String? {
        ["FR": "francis", "TS": "tyrone", "FN": "franck",
         "LS": "lance", "JD": "jay", "CC": "carlo"][initials]
    }

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Group {
                if useSamplePhoto, let asset {
                    Image(asset).resizable().scaledToFill()
                } else {
                    AppColors.mint.overlay {
                        Text(initials).font(.headline).foregroundStyle(AppColors.primary)
                    }
                }
            }
            .frame(width: size, height: size)
            .clipShape(RoundedRectangle(cornerRadius: size * 0.35))
            if isOnline {
                Circle().fill(AppColors.primary)
                    .frame(width: 12, height: 12)
                    .overlay(Circle().stroke(.white, lineWidth: 3))
            }
        }
        .accessibilityLabel(initials)
    }
}
