//
//  DoWorkoutViewModel.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 5/17/23.
//

import Foundation
import Core

// MARK: - Events

enum DoWorkoutViewEvent {
    case loadWorkout
}

// MARK: - View Model

final class DoWorkoutViewModel: ViewModel {
    @Published private(set) var viewState: DoWorkoutViewState = .loading
    private let interactor: DoWorkoutInteractor
    private let reducer = DoWorkoutReducer()
    
    init(interactor: DoWorkoutInteractor) {
        self.interactor = interactor
    }
    
    func send(_ event: DoWorkoutViewEvent) async {
        switch event {
        case .loadWorkout:
            await react(domainAction: .loadWorkout)
        }
    }
}

// MARK: - Private

private extension DoWorkoutViewModel {
    func updateViewState(_ viewState: DoWorkoutViewState) async {
        await MainActor.run {
            self.viewState = viewState
        }
    }
    
    func react(domainAction: DoWorkoutDomainAction) async {
        let domain: DoWorkoutDomainResult = await interactor.interact(with: domainAction)
        let newViewState = reducer.reduce(domain)
        await updateViewState(newViewState)
    }
}
