//
//  SettingsDisplay.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 7/31/23.
//

import DesignSystem

struct SettingsDisplay: Equatable {
    let sections: [SettingsSection]
    let versionString: String?
    let buildNumberString: String?
}
