//
//  SettingsViewModel.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 7/17/22.
//

import Foundation
import Core

// MARK: - Events

enum SettingsViewEvent {
    case load
}

// MARK: - View Model

final class SettingsViewModel: ViewModel {
    @Published private(set) var viewState: SettingsViewState = .loading
    private let interactor: SettingsInteractor
    private let reducer = SettingsReducer()
    
    init(interactor: SettingsInteractor) {
        self.interactor = interactor
    }
    
    func send(_ event: SettingsViewEvent) async {
        switch event {
        case .load:
            await react(domainAction: .load)
        }
    }
}

// MARK: - Private

private extension SettingsViewModel {
    func updateViewState(_ viewState: SettingsViewState) async {
        await MainActor.run {
            self.viewState = viewState
        }
    }
    
    func react(domainAction: SettingsDomainAction) async {
        let domain = await interactor.interact(with: domainAction)
        let newViewState = reducer.reduce(domain)
        await updateViewState(newViewState)
    }
}
