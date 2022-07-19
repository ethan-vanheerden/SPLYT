//
//  SettingsItem.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 7/17/22.
//

import Foundation

enum SettingsItem: Equatable, CaseIterable {
    case designShowcase
    
    var title: String {
        switch self {
        case .designShowcase:
            return "DESIGN SHOWCASE"
        }
    }
    
    var subtitle: String? {
        return nil
    }
}
