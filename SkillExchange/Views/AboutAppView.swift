import SwiftUI

struct AboutAppView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                SectionHeading(eyebrow: "Campus edition", title: "Everyone has something to share.")
                VStack(alignment: .leading, spacing: 16) {
                    Label("Teach what you know", systemImage: "hand.raised.fingers.spread.fill").font(.headline)
                    Text("Add the skills you can teach, then list the skills you want to learn. Find a partner and propose a fair exchange.")
                        .foregroundStyle(AppColors.secondaryText)
                }.campusCard()
                VStack(alignment: .leading, spacing: 14) {
                    Text("About this version").font(.headline)
                    Text("This version uses Firebase accounts and saves your skills, introduction and availability online for each account.")
                    Text("Discovery and inbox still show sample people. Exchange proposals are local demonstrations and last for one session. Real matching, exchanges and chat will follow.")
                    Text("Sign in again to load your saved profile. An internet connection is required to load and save your profile.")
                }.font(.subheadline).foregroundStyle(AppColors.secondaryText).campusCard()
            }.padding(24)
        }.background(AppColors.background)
            .navigationTitle("About").navigationBarTitleDisplayMode(.inline)
            .toolbar(.visible, for: .navigationBar)
    }
}
