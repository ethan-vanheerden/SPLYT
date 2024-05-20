//
//  AppIcon.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 5/20/24.
//

import Foundation

enum AppIcon: String, CaseIterable {
    case primary = "AppIcon"
    case pulse = "AppIcon-Pulse"
    case breeze = "AppIcon-Breeze"
    case miami = "AppIcon-Miami"
    case flare = "AppIcon-Flare"
    case charcoal = "AppIcon-Charcoal"
    case black = "AppIcon-Black"
    case white = "AppIcon-White"
    
    var iconName: String? {
        switch self {
        case .primary:
            return nil // nil sets back to default icon
        default:
            return rawValue
        }
    }
}
