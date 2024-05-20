//
//  AppearanceViewModel.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 5/20/24.
//

import Foundation
import UIKit
import SwiftUI
import DesignSystem

/// Inspired by https://www.avanderlee.com/swift/alternate-app-icon-configuration-in-xcode/
final class AppearanceViewModel: ObservableObject {
    @AppStorage("userTheme") private(set) var userTheme: SplytColor = .blue
    @Published private(set) var appIcon: AppIcon
    
    init() {
        if let iconName = UIApplication.shared.alternateIconName, 
            let appIcon = AppIcon(rawValue: iconName) {
            self.appIcon = appIcon
        } else {
            self.appIcon = .primary
        }
    }
    
    @MainActor
    func updateUserTheme(to theme: SplytColor) {
        userTheme = theme
    }
    
    @MainActor
    func updateAppIcon(to icon: AppIcon) async {
        let iconName = icon.iconName
        
        guard UIApplication.shared.alternateIconName != iconName else { return }
        
        do {
            appIcon = icon
            try await UIApplication.shared.setAlternateIconName(iconName)
        } catch { }
    }
}
