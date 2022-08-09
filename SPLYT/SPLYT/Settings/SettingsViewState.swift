//
//  SettingsViewState.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 7/17/22.
//

import Foundation
import DesignSystem

enum SettingsViewState: Equatable {
    case loading
    case main(items: [MenuItemViewState])
    case networkResponse(TestNetworkObject)
    case error
}
