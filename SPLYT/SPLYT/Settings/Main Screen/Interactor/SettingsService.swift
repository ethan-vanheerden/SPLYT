//
//  SettingsService.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 8/27/23.
//

import Foundation

// MARK: - Protocol

protocol SettingsServiceType {
    /// Signs out the current user.
    /// - Returns: Whether the operation was successful or not
    func signOut() -> Bool
}

// MARK: - Implementation

struct SettingsService: SettingsServiceType {
    private let userAuth: UserAuthType
    
    init(userAuth: UserAuthType = UserAuth()) {
        self.userAuth = userAuth
    }
    
    func signOut() -> Bool{
        return userAuth.logout()
    }
}
