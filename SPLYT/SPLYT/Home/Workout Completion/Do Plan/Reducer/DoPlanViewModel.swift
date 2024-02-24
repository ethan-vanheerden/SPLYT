//
//  DoPlanViewModel.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 7/4/23.
//

import Foundation
import Core

// MARK: - Events

enum DoPlanViewEvent {
    case load
    case deleteWorkout(workoutId: String)
}

// MARK: - View Model

final class DoPlanViewModel: ViewModel {
    @Published private(set) var viewState: DoPlanViewState = .loading
    private let interactor: DoPlanInteractor
    private let reducer: DoPlanReducer = DoPlanReducer()
    
    init(interactor: DoPlanInteractor) {
        self.interactor = interactor
    }
    
    func send(_ event: DoPlanViewEvent) async {
        switch event {
        case .load:
            await react(domainAction: .load)
        case .deleteWorkout(let workoutId):
            await react(domainAction: .deleteWorkout(workoutId: workoutId))
        }
    }
}

// MARK: - Private

private extension DoPlanViewModel {
    func updateViewState(_ viewState: DoPlanViewState) async {
        await MainActor.run {
            self.viewState = viewState
        }
    }
    
    func react(domainAction: DoPlanDomainAction) async {
        let domain = await interactor.interact(with: domainAction)
        let newViewState = reducer.reduce(domain)
        await updateViewState(newViewState)
    }
}
