import SwiftUI

struct SectionHeading: View {
    let eyebrow: String
    let title: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(eyebrow.uppercased()).font(.caption2.bold())
                .tracking(2).foregroundStyle(AppColors.primary)
            Text(title).font(.system(.largeTitle, design: .rounded, weight: .bold))
                .foregroundStyle(AppColors.ink)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
