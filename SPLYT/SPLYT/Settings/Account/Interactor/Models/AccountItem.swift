//
//  AccountItem.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 10/17/24.
//

import DesignSystem

enum AccountItem: Equatable, CaseIterable {
    case signOut
    case deleteAccount
    
    var title: String {
        switch self {
        case .signOut:
            "Sign Out"
        case .deleteAccount:
            "Delete Account"
        }
    }
    
    var imageName: String {
        switch self {
        case .signOut:
            "hand.wave.fill"
        case .deleteAccount:
            "exclamationmark.triangle.fill"
        }
    }
    
    var backgroundColor: SplytColor {
        switch self {
        case .signOut:
            .gray
        case .deleteAccount:
            .red
        }
    }
}
