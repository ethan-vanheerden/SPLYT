//
//  SettingsSection.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 7/31/23.
//

import Foundation

struct SettingsSection: Hashable {
    let title: String
    let items: [SettingsItem]
    let isEnabled: Bool
}
