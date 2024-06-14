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
    case startRest(restSeconds: Int)
    case stopRest(manuallyStopped: Bool)
    case toggleGroupExpand(group: Int, isExpanded: Bool)
    case completeGroup(group: Int)
    case addSet(group: Int)
    case removeSet(group: Int)
    case updateSet(group: Int, exerciseIndex: Int, setIndex: Int, with: SetInput, forModifier: Bool)
    case usePreviousInput(group: Int, exerciseIndex: Int, setIndex: Int, forModifier: Bool)
    case toggleDialog(dialog: DoWorkoutDialog, isOpen: Bool)
    case saveWorkout
    case cacheWorkout(secondElapsed: Int)
    case pauseRest
    case resumeRest(restSeconds: Int)
    case deleteExercise(group: Int, exerciseIndex: Int)
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
            await react(domainAction: .loadWorkout, updateTime: true)
        case .stopCountdown:
            await startTime() // Start the workout timer
            await react(domainAction: .stopCountdown)
        case .startRest(let restSeconds):
            await react(domainAction: .startRest(restSeconds: restSeconds))
        case .stopRest(let manuallyStopped):
            await react(domainAction: .stopRest(manuallyStopped: manuallyStopped))
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
        case let .toggleDialog(dialog, isOpen):
            await react(domainAction: .toggleDialog(dialog: dialog, isOpen: isOpen))
        case .saveWorkout:
            await react(domainAction: .saveWorkout)
            await stopTime()
        case .cacheWorkout(let secondsElapsed):
            // Don't need to update view, just make the interactor call
            _ = await interactor.interact(with: .cacheWorkout(secondsElapsed: secondsElapsed))
        case .pauseRest:
            await react(domainAction: .pauseRest)
        case .resumeRest(let restSeconds):
            await react(domainAction: .resumeRest(restSeconds: restSeconds))
        case let .deleteExercise(group, exerciseIndex):
            await react(domainAction: .deleteExercise(group: group, exerciseIndex: exerciseIndex))
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
    
    func react(domainAction: DoWorkoutDomainAction, updateTime: Bool = false) async {
        let domainResult: DoWorkoutDomainResult = await interactor.interact(with: domainAction)
        
        if updateTime, 
            case .loaded(let domain) = domainResult,
            let secondsElapsed = domain.cachedSecondsElapsed {
            await startTime(secondsElapsed: secondsElapsed)
        }
        
        let newViewState = reducer.reduce(domainResult)
        await updateViewState(newViewState)
    }
}
