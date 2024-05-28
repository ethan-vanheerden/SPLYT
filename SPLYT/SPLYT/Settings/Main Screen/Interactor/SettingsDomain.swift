//
//  SettingsDomain.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 7/31/23.
//

import Foundation

struct SettingsDomain: Equatable {
    let sections: [SettingsSection]
    let versionString: String?
    let buildNumberString: String?
}

// MARK: - Dialog Type

enum SettingsDialog: Equatable {
    case signOut
}
