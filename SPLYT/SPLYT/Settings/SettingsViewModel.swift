//
//  SettingsViewModel.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 7/17/22.
//

import Foundation
import Core
import DesignSystem

final class SettingsViewModel: ViewModel {
    @Published private(set) var viewState: SettingsViewState = .loading
    private let interactor: SettingsInteractorType
    
    init(interactor: SettingsInteractorType) {
        self.interactor = interactor
    }

    func send(_ event: SettingsViewEvent) async {
        switch event {
        case .load:
            let domainState = await interactor.interact(with: .load)
            switch domainState {
            case .loaded(let testNetworkObject):
                await updateViewState(.networkResponse(testNetworkObject))
            case .error:
                await updateViewState(.error)
            }
        case .menuItems:
            await updateViewState(.main(items: getMenuItems()))
        }
    }
}

// MARK: - Private

private extension SettingsViewModel {
    func getMenuItems() -> [MenuItemViewState] {
        return SettingsItem.allCases.map {
            /// The `id` field is the enum value so we know which view to navigate to when it is tapped
            MenuItemViewState(id: $0, title: $0.title, subtitle: $0.subtitle)
        }
    }
    
    func updateViewState(_ viewState: SettingsViewState) async {
        await MainActor.run {
            self.viewState = viewState
        }
    }
}

// MARK: - Events

enum SettingsViewEvent {
    case load
    case menuItems
}
