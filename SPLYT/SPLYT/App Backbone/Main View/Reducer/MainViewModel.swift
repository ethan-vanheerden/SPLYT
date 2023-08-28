//
//  MainViewModel.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 7/4/22.
//

import Foundation
import Core

// MARK: - Events

enum MainViewEvent {
    case load
}

// MARK: - View Model

final class MainViewModel: ViewModel {
    @Published private(set) var viewState: MainViewState = .loading
    private let interactor: MainViewInteractor
    private let reducer = MainViewReducer()
    
    init(interactor: MainViewInteractor) {
        self.interactor = interactor
    }
    
    func send(_ event: MainViewEvent) async {
        switch event {
        case .load:
            await react(domainAction: .load)
        }
    }
}

// MARK: - Private

private extension MainViewModel {
    func updateViewState(_ viewState: MainViewState) async {
        await MainActor.run {
            self.viewState = viewState
        }
    }
    
    func react(domainAction: MainViewDomainAction) async {
        let domain = await interactor.interact(with: domainAction)
        let newViewState = reducer.reduce(domain)
        await updateViewState(newViewState)
    }
}
