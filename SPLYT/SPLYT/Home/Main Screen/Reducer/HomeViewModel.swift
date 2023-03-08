//
//  HomeViewModel.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 12/20/22.
//

import Foundation
import Core

// MARK: - Events

enum HomeViewEvent {
    case load
    case deleteWorkout(id: String)
}

// MARK: - View Model

final class HomeViewModel: ViewModel {
    @Published private(set) var viewState: HomeViewState = .loading
    private let interactor: HomeInteractorType
    private let reducer = HomeReducer()
    
    init(interactor: HomeInteractorType = HomeInteractor()) {
        self.interactor = interactor
    }
    
    func send(_ event: HomeViewEvent) async {
        switch event {
        case .load:
            await react(domainAction: .load)
        case .deleteWorkout(let id):
            await react(domainAction: .deleteWorkout(id: id))
        }
    }
}

// MARK: - Private

private extension HomeViewModel {
    func updateViewState(_ viewState: HomeViewState) async {
        await MainActor.run {
            self.viewState = viewState
        }
    }

    func react(domainAction: HomeDomainAction) async {
        let domain = await interactor.interact(with: domainAction)
        let newViewState = reducer.reduce(domain)
        await updateViewState(newViewState)
    }
}
