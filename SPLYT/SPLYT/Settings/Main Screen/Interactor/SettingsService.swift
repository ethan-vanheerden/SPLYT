//
//  SettingsService.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 7/31/23.
//

import Foundation
import UserSettings

// MARK: - Protocol

protocol SettingsServiceType {
    
}

// MARK: - Implementation

struct SettingsService: SettingsServiceType {
    private let userSettings: UserSettings
    
    init(userSettings: UserSettings = UserDefaults.standard) {
        self.userSettings = userSettings
    }
}

