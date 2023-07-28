//
//  WorkoutDetailsViewModel.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 7/20/23.
//

import Foundation
import Core

// MARK: - Events

enum WorkoutDetailsViewEvent {
    case load
    case toggleGroupExpand(group: Int, isExpanded: Bool)
    case toggleDialog(dialog: WorkoutDetailsDialog, isOpen: Bool)
    case delete
}

// MARK: - View Model

final class WorkoutDetailsViewModel: ViewModel {
    @Published private(set) var viewState: WorkoutDetailsViewState = .loading
    private let interactor: WorkoutDetailsInteractor
    private let reducer = WorkoutDetailsReducer()
    
    init(interactor: WorkoutDetailsInteractor) {
        self.interactor = interactor
    }
    
    func send(_ event: WorkoutDetailsViewEvent) async {
        switch event {
        case .load:
            await react(domainAction: .load)
        case let .toggleGroupExpand(group, isExpanded):
            await react(domainAction: .toggleGroupExpand(group: group, isExpanded: isExpanded))
        case let .toggleDialog(dialog, isOpen):
            await react(domainAction: .toggleDialog(dialog: dialog, isOpen: isOpen))
        case .delete:
            await react(domainAction: .delete)
        }
    }
}

// MARK: - Private

private extension WorkoutDetailsViewModel {
    func updateViewState(_ viewState: WorkoutDetailsViewState) async {
        await MainActor.run {
            self.viewState = viewState
        }
    }
    
    func react(domainAction: WorkoutDetailsDomainAction) async {
        let domain = await interactor.interact(with: domainAction)
        let newViewState = reducer.reduce(domain)
        await updateViewState(newViewState)
    }
}
