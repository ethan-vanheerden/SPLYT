//
//  NameWorkoutViewModel.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 1/6/23.
//

import Foundation
import Core

// MARK: - Events

enum NameWorkoutViewEvent {
    case load
    case updateWorkoutName(name: String)
}

// MARK: - View Model

/// Used for both naming a workout and a plan
final class NameWorkoutViewModel: ViewModel {
    @Published private(set) var viewState: NameWorkoutViewState = .loading
    private let interactor: NameWorkoutInteractor
    private let reducer = NameWorkoutReducer()
    
    init(interactor: NameWorkoutInteractor) {
        self.interactor = interactor
    }
    
    func send(_ event: NameWorkoutViewEvent) async {
        switch event {
        case .load:
            await react(domainAction: .load)
        case .updateWorkoutName(let name):
            await react(domainAction: .updateWorkoutName(name: name))
        }
    }
}

// MARK: - Private

private extension NameWorkoutViewModel {
    func updateViewState(_ viewState: NameWorkoutViewState) async {
        await MainActor.run {
            self.viewState = viewState
        }
    }
    
    func react(domainAction: NameWorkoutDomainAction) async {
        let domain = await interactor.interact(with: domainAction)
        let newViewState = reducer.reduce(domain)
        await updateViewState(newViewState)
    }
}
