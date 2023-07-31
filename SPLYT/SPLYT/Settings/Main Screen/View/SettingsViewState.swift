//
//  SettingsViewState.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 7/17/22.
//

import DesignSystem

enum SettingsViewState: Equatable {
    case loading
    case error
    case loaded(SettingsDisplay)
}
