//
//  SPLYTApp.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 7/3/22.
//

import SwiftUI

@main
struct SPLYTApp: App {
    // @StateObject private var userSettings = UserSettings()
    var body: some Scene {
        WindowGroup {
            MainViewHostingController_SwiftUI()
//                .environmentObject(UserSettings()) -> This would allow us to access the all of the user info we need throughout the app
        }
    }
}
