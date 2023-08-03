//
//  RestPresetsViewModel.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 8/1/23.
//

import Foundation
import Core

// MARK: - Events

enum RestPresetsViewEvent {
    case load
    case updatePresets(newPresets: [Int])
    case updatePreset(index: Int, minutes: Int, seconds: Int)
}

// MARK: - View Model

final class RestPresetsViewModel: ViewModel {
    @Published private(set) var viewState: RestPresetsViewState = .loading
    private let interactor: RestPresetsInteractor
    private let reducer = RestPresetsReducer()
    
    init(interactor: RestPresetsInteractor) {
        self.interactor = interactor
    }
    
    func send(_ event: RestPresetsViewEvent) async {
        switch event {
        case .load:
            await react(domainAction: .load)
        case .updatePresets(let newPresets):
            await react(domainAction: .updatePresets(newPresets: newPresets))
        case let .updatePreset(index, minutes, seconds):
            await react(domainAction: .updatePreset(index: index, minutes: minutes, seconds: seconds))
        }
    }
}

// MARK: - Private

private extension RestPresetsViewModel {
    func updateViewState(_ viewState: RestPresetsViewState) async {
        await MainActor.run {
            self.viewState = viewState
        }
    }
    
    func react(domainAction: RestPresetsDomainAction) async {
        let domain = await interactor.interact(with: domainAction)
        let newViewState = reducer.reduce(domain)
        await updateViewState(newViewState)
    }
}
