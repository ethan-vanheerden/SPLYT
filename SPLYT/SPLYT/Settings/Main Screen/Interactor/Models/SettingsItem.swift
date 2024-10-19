//
//  SettingsItem.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 7/17/22.
//

import Foundation
import DesignSystem
import SwiftUI

enum SettingsItem: Equatable, CaseIterable {
    case designShowcase
    case restPresets
    case appearance
    case submitFeedback
    case about
    case account
    
    var title: String {
        switch self {
        case .designShowcase:
            return "Design Showcase"
        case .restPresets:
            return "Rest Presets"
        case .appearance:
            return "Appearance"
        case .submitFeedback:
            return "Submit Feedback"
        case .about:
            return "About"
        case .account:
            return "Account"
        }
    }
    
    var subtitle: String? {
        return nil
    }
    
    var isEnabled: Bool {
        return true
    }
    
    var imageName: String {
        switch self {
        case .designShowcase:
            return "theatermask.and.paintbrush.fill"
        case .restPresets:
            return "stopwatch.fill"
        case .appearance:
            return "paintbrush.fill"
        case .submitFeedback:
            return "envelope.fill"
        case .about:
            return "info.circle.fill"
        case .account:
            return "person.fill"
        }
    }
    
    var backgroundColor: SplytColor {
        switch self {
        case .designShowcase:
            return .darkBlue
        case .restPresets:
            return .blue
        case .appearance:
            return UserTheme.shared.theme
        case .submitFeedback:
            return .green
        case .about:
            return .gray
        case .account:
            return .gray
        }
    }
    
    var detail: SettingsItemDetail {
        switch self {
        case .submitFeedback:
            let formURL = "https://forms.gle/bk1b87QBP2ZogKH4A"
            return .link(url: formURL)
        default:
            return .navigation
        }
    }
}


enum SettingsItemDetail: Equatable {
    case navigation
    case link(url: String)
    case button
}
