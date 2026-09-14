//
//  SkillExchangeApp.swift
//  SkillExchange
//
//  Created by Mac-LAB on 9/2/26.
//

import SwiftUI

@main
struct SkillExchangeApp: App {
    @StateObject private var appController = AppController()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appController)
                .preferredColorScheme(.light)
                .tint(AppColors.primary)
                .foregroundStyle(AppColors.ink)
        }
    }
}
