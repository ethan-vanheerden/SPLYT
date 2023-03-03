//
//  TabType.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 7/3/22.
//

import Foundation
import SwiftUI


/// The options for the app's navigation tab bar.
enum TabType: CaseIterable {
    case home
    case profile
    case settings
    
    /// The image name for the icon displayed
    var imageName: String {
        switch self {
        case .home:
            return "dumbbell.fill"
        case .profile:
            return "person.crop.circle"
        case .settings:
            return "gear"
        }
    }
    
    /// The title displayed for the tab item
    var title: String {
        switch self {
        case .home:
            return Strings.home
        case .profile:
            return Strings.profile
        case .settings:
            return Strings.settings
        }
    }
}

// MARK: - String Constants

fileprivate struct Strings {
    static let home = "Home"
    static let profile = "Profile"
    static let settings = "Settings"
}
