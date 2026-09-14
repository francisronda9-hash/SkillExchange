import SwiftUI

enum AppColors {
    static let primary = Color(red: 0.02, green: 0.39, blue: 0.37)
    static let darkRed = Color(red: 0.07, green: 0.14, blue: 0.20)
    static let background = Color(red: 0.97, green: 0.96, blue: 0.93)
    static let card = Color.white
    static let secondaryText = Color(red: 0.39, green: 0.44, blue: 0.46)
    static let lightRed = Color(red: 0.86, green: 0.94, blue: 0.89)
    static let ink = darkRed
    static let mint = lightRed
    static let coral = Color(red: 1, green: 0.80, blue: 0.68)
    static let lavender = Color(red: 0.88, green: 0.86, blue: 0.98)
}

extension View {
    func campusCard() -> some View {
        padding(20)
            .background(AppColors.card)
            .clipShape(RoundedRectangle(cornerRadius: 24))
    }
}
