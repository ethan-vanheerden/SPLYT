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
    case stopCountdown
    case toggleRest(isResting: Bool)
}

// MARK: - View Model

final class DoWorkoutViewModel: TimeViewModel<DoWorkoutViewState, DoWorkoutViewEvent> {
    private let interactor: DoWorkoutInteractor
    private let reducer = DoWorkoutReducer()
    
    init(interactor: DoWorkoutInteractor) {
        self.interactor = interactor
        super.init(viewState: .loading)
    }
    
    override func send(_ event: DoWorkoutViewEvent) async {
        switch event {
        case .loadWorkout:
            await react(domainAction: .loadWorkout)
        case .stopCountdown:
            await startTime() // Start the workout timer
            await react(domainAction: .stopCountdown)
        case .toggleRest(let isResting):
            await react(domainAction: .toggleRest(isResting: isResting))
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
