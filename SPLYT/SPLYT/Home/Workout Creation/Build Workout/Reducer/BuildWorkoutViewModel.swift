//
//  BuildWorkoutViewModel.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 1/11/23.
//

import Foundation
import Core
import ExerciseCore

// MARK: - Events

enum BuildWorkoutViewEvent {
    case load
    case addGroup
    case removeGroup(group: Int)
    case toggleExercise(exerciseId: AnyHashable, group: Int)
    case addSet(group: Int)
    case removeSet(group: Int)
    case updateSet(group: Int, exerciseIndex: Int, setIndex: Int, with: SetInput)
    case toggleFavorite(exerciseId: AnyHashable)
    case switchGroup(to: Int)
    case save
    case toggleDialog(type: BuildWorkoutDialog, isOpen: Bool)
    case addModifier(group: Int, exerciseIndex: Int, setIndex: Int, modifier: SetModifier)
    case removeModifier(group: Int, exerciseIndex: Int, setIndex: Int)
    case updateModifier(group: Int, exerciseIndex: Int, setIndex: Int, with: SetInput)
    case filter(by: BuildWorkoutFilter)
    case removeAllFilters
}

// MARK: - View Model

final class BuildWorkoutViewModel: ViewModel {
    @Published private(set) var viewState: BuildWorkoutViewState = .loading
    private let interactor: BuildWorkoutInteractor
    private let reducer = BuildWorkoutReducer()
    
    init(interactor: BuildWorkoutInteractor) {
        self.interactor = interactor
    }
    
    func send(_ event: BuildWorkoutViewEvent) async {
        switch event {
        case .load:
            await react(domainAction: .loadExercises)
        case .addGroup:
            await react(domainAction: .addGroup)
        case .removeGroup(let group):
            await react(domainAction: .removeGroup(group: group))
        case let .toggleExercise(exerciseId, group):
            await react(domainAction: .toggleExercise(exerciseId: exerciseId, group: group))
        case .addSet(let group):
            await react(domainAction: .addSet(group: group))
        case .removeSet(let group):
            await react(domainAction: .removeSet(group: group))
        case let .updateSet(group, exerciseIndex, setIndex, newInput):
            await react(domainAction: .updateSet(group: group,
                                                 exerciseIndex: exerciseIndex,
                                                 setIndex: setIndex,
                                                 with: newInput))
        case .toggleFavorite(let exerciseId):
            await react(domainAction: .toggleFavorite(exerciseId: exerciseId))
        case .switchGroup(let group):
            await react(domainAction: .switchGroup(to: group))
        case .save:
            await react(domainAction: .save)
        case let .toggleDialog(type, isOpen):
            await react(domainAction: .toggleDialog(type: type, isOpen: isOpen))
        case let .addModifier(group, exerciseIndex, setIndex, modifier):
            await react(domainAction: .addModifier(group: group,
                                                   exerciseIndex: exerciseIndex,
                                                   setIndex: setIndex,
                                                   modifier: modifier))
        case let .removeModifier(group, exerciseIndex, setIndex):
            await react(domainAction: .removeModifier(group: group,
                                                      exerciseIndex: exerciseIndex,
                                                      setIndex: setIndex))
        case let .updateModifier(group, exerciseIndex, setIndex, newInput):
            await react(domainAction: .updateModifier(group: group,
                                                      exerciseIndex: exerciseIndex,
                                                      setIndex: setIndex,
                                                      with: newInput))
        case .filter(let filter):
            await react(domainAction: .filter(by: filter))
        case .removeAllFilters:
            await react(domainAction: .removeAllFilters)
        }
    }
}

// MARK: - Private

private extension BuildWorkoutViewModel {
    func updateViewState(_ viewState: BuildWorkoutViewState) async {
        await MainActor.run {
            self.viewState = viewState
        }
    }
    
    func react(domainAction: BuildWorkoutDomainAction) async {
        let domain = await interactor.interact(with: domainAction)
        let newViewState = reducer.reduce(domain)
        await updateViewState(newViewState)
    }
}
