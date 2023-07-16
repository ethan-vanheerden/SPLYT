//
//  BuildPlanViewModel.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 6/18/23.
//

import Foundation
import Core
import ExerciseCore

// MARK: - Events

enum BuildPlanViewEvent {
    case load
    case addWorkout(Workout)
    case removeWorkout(workoutId: String)
    case savePlan
    case toggleDialog(dialog: BuildPlanDialog, isOpen: Bool)
}

// MARK: - View Model

final class BuildPlanViewModel: ViewModel {
    @Published private(set) var viewState: BuildPlanViewState = .loading
    private let interactor: BuildPlanInteractor
    private let reducer = BuildPlanReducer()
    
    init(interactor: BuildPlanInteractor) {
        self.interactor = interactor
    }
    
    func send(_ event: BuildPlanViewEvent) async {
        switch event {
        case .load:
            await react(domainAction: .load)
        case .addWorkout(let workout):
            await react(domainAction: .addWorkout(workout: workout))
        case .removeWorkout(let workoutId):
            await react(domainAction: .removeWorkout(workoutId: workoutId))
        case .savePlan:
            await react(domainAction: .savePlan)
        case let .toggleDialog(dialog, isOpen):
            await react(domainAction: .toggleDialog(dialog: dialog, isOpen: isOpen))
        }
    }
}

// MARK: - Private

private extension BuildPlanViewModel {
    func updateViewState(_ viewState: BuildPlanViewState) async {
        await MainActor.run {
            self.viewState = viewState
        }
    }
    
    func react(domainAction: BuildPlanDomainAction) async {
        let domain = await interactor.interact(with: domainAction)
        let newViewState = reducer.reduce(domain)
        await updateViewState(newViewState)
    }
}
