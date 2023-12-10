//
//  RestPresetsService.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 8/1/23.
//

import Foundation
import UserSettings

// MARK: - Protocol

protocol RestPresetsServiceType {
    func getPresets() -> [Int]
    
    func updatePresets(newPresets: [Int])
}

// MARK: - Errors

enum RestPresetsError: Error {
    case presetsNotFound
}

// MARK: - Implementation

struct RestPresetsService: RestPresetsServiceType {
    private let userSettings: UserSettings
    private let fallbackPresets: [Int] = [60, 90, 120]
    
    init(userSettings: UserSettings = UserDefaults.standard) {
        self.userSettings = userSettings
    }
    
    func getPresets() -> [Int] {
        let presets = userSettings.object(forKey: .restPresets)
        
        guard let presets = presets as? [Int] else {
            // If not found, save the starting presets
            updatePresets(newPresets: fallbackPresets)
            return fallbackPresets
        }
        
        return presets
    }
    
    func updatePresets(newPresets: [Int]) {
        userSettings.set(newPresets, forKey: .restPresets)
    }
}
