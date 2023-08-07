//
//  SPLYTApp.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 7/3/22.
//

import SwiftUI

@main
struct SPLYTApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var delegate
    
    var body: some Scene {
        WindowGroup {
            MainViewHostingController_SwiftUI()
                .ignoresSafeArea(.all)
                .preferredColorScheme(.light)
        }
    }
}
