//
//  BuildWorkoutViewModel.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 1/11/23.
//

import Foundation
import Core

// MARK: - Events

enum BuildWorkoutViewEvent {
    case load
    case addGroup
    case removeGroup(group: Int)
    case toggleExercise(id: AnyHashable, group: Int)
    case addSet(group: Int)
    case removeSet(group: Int)
    case updateSet(id: AnyHashable, group: Int, with: SetInputType)
    case toggleFavorite(id: AnyHashable)
    case switchGroup(to: Int)
    case save
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
        case let .toggleExercise(id, group):
            await react(domainAction: .toggleExercise(id: id, group: group))
        case .addSet(let group):
            await react(domainAction: .addSet(group: group))
        case .removeSet(let group):
            await react(domainAction: .removeSet(group: group))
        case let .updateSet(id, group, newInput):
            await react(domainAction: .updateSet(id: id, group: group, with: newInput))
        case .toggleFavorite(let id):
            await react(domainAction: .toggleFavorite(id: id))
        case .switchGroup(let group):
            await react(domainAction: .switchGroup(to: group))
        case .save:
            await react(domainAction: .save)
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
