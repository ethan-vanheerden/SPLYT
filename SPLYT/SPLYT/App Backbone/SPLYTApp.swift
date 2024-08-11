//
//  SPLYTApp.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 7/3/22.
//

import SwiftUI
import DesignSystem

@main
struct SPLYTApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var delegate
    
    var body: some Scene {
        WindowGroup {
            MainViewController_SwiftUI()
                .withAppearanceTheme()
                .withUserTheme()
                .ignoresSafeArea(.all)
        }
    }
}
