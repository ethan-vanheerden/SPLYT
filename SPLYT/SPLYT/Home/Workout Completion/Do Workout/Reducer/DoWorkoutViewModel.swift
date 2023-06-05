//
//  DoWorkoutViewModel.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 5/17/23.
//

import Foundation
import Core
import ExerciseCore

// MARK: - Events

enum DoWorkoutViewEvent {
    case loadWorkout
    case stopCountdown
    case toggleRest(isResting: Bool)
    case toggleGroupExpand(group: Int, isExpanded: Bool)
    case completeGroup(group: Int)
    case addSet(group: Int)
    case removeSet(group: Int)
    case updateSet(group: Int, exerciseIndex: Int, setIndex: Int, with: SetInput, forModifier: Bool)
    case usePreviousInput(group: Int, exerciseIndex: Int, setIndex: Int, forModifier: Bool)
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
        case let .toggleGroupExpand(group, isExpanded):
            await react(domainAction: .toggleGroupExpand(group: group, isExpanded: isExpanded))
        case .completeGroup(let group):
            await react(domainAction: .completeGroup(group: group))
        case .addSet(let group):
            await react(domainAction: .addSet(group: group))
        case .removeSet(let group):
            await react(domainAction: .removeSet(group: group))
        case let .updateSet(group, exerciseIndex, setIndex, newInput, forModifier):
            await react(domainAction: .updateSet(group: group,
                                                 exerciseIndex: exerciseIndex,
                                                 setIndex: setIndex,
                                                 with: newInput,
                                                 forModifier: forModifier))
        case let .usePreviousInput(group, exerciseIndex, setIndex, forModifier):
            await react(domainAction: .usePreviousInput(group: group,
                                                        exerciseIndex: exerciseIndex,
                                                        setIndex: setIndex,
                                                        forModifier: forModifier))
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
