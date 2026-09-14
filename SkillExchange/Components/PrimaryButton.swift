import SwiftUI

struct PrimaryButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                Spacer()
                Image(systemName: "arrow.up.right")
            }
            .font(.system(.body, design: .rounded, weight: .semibold))
            .padding(18)
            .foregroundStyle(.white)
            .background(AppColors.primary)
            .clipShape(RoundedRectangle(cornerRadius: 18))
        }
        .buttonStyle(.plain)
    }
}
