//
//  SettingsItem.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 7/17/22.
//

import Foundation
import DesignSystem

enum SettingsItem: Equatable, CaseIterable {
    case designShowcase
    case restPresets
    case submitFeedback
    case signOut
    
    var title: String {
        switch self {
        case .designShowcase:
            return "Design Showcase"
        case .restPresets:
            return "Rest Presets"
        case .submitFeedback:
            return "Submit Feedback"
        case .signOut:
            return "Sign Out"
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
        case .submitFeedback:
            return "envelope.fill"
        case .signOut:
            return "person.fill"
        }
    }
    
    var backgroundColor: SplytColor {
        switch self {
        case .designShowcase:
            return .purple
        case .restPresets:
            return .blue
        case .submitFeedback:
            return .green
        case .signOut:
            return .gray
        }
    }
    
    var detail: SettingsItemDetail {
        switch self {
        case .submitFeedback:
            let formURL = "https://forms.gle/bk1b87QBP2ZogKH4A"
            return .link(url: formURL)
        case .signOut:
            return .button
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
