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
    case deleteWorkout(id: String, filename: String?)
    case deletePlan(id: String)
    case toggleDialog(type: HomeDialog, isOpen: Bool)
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
        case let .deleteWorkout(id, filename):
            await react(domainAction: .deleteWorkout(id: id, filename: filename))
        case .deletePlan(let id):
            await react(domainAction: .deletePlan(id: id))
        case let .toggleDialog(type, isOpen):
            await react(domainAction: .toggleDialog(type: type, isOpen: isOpen))
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
