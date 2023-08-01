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
    
    var title: String {
        switch self {
        case .designShowcase:
            return "Design Showcase"
        case .restPresets:
            return "Rest Presets"
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
        }
    }
    
    var backgroundColor: SplytColor {
        switch self {
        case .designShowcase:
            return .purple
        case .restPresets:
            return .lightBlue
        }
    }
}
