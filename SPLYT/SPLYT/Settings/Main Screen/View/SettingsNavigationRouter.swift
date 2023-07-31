//
//  SettingsNavigationRouter.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 7/16/22.
//

import Foundation
import Core
import DesignSystem
import SwiftUI
import DesignShowcase

// MARK: - Navigation Events

enum SettingsNavigationEvent {
    case menuItem(MenuItemViewState)
}

// MARK: - Router

final class SettingsNavigationRouter: NavigationRouter {
    weak var navigator: Navigator?
    
    func navigate(_ event: SettingsNavigationEvent) {
        switch event {
        case .menuItem(let viewState):
            handleNavigateMenuItem(viewState: viewState)
        }
    }
}


// MARK: - Private

private extension SettingsNavigationRouter {
    func handleNavigateMenuItem(viewState: MenuItemViewState) {
        guard let item = viewState.id as? SettingsItem else {
            return
        }
        switch item {
        case .designShowcase:
            let vc = DesignShowcaseProvider.designShowcaseHostingController()
            navigator?.push(vc, animated: true)
        }
    }
}
