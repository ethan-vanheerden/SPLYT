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
    
    var imageResource: ImageResource {
        switch self {
        case .primary:
            return .appIcon
        case .pulse:
            return .appIconPulse
        case .breeze:
            return .appIconBreeze
        case .miami:
            return .appIconMiami
        case .flare:
            return .appIconFlare
        case .charcoal:
            return .appIconCharcoal
        case .black:
            return .appIconBlack
        case .white:
            return .appIconWhite
        }
    }
}
