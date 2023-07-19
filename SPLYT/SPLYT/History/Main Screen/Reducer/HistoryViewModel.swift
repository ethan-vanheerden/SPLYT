//
//  HistoryViewModel.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 7/16/23.
//

import Foundation
import Core

// MARK: - Events

enum HistoryViewEvent {
    case load
    case deleteWorkoutHistory(workoutId: String, completionDate: Date?)
    case toggleDialog(dialog: HistoryDialog, isOpen: Bool)
}

// MARK: - View Model

final class HistoryViewModel: ViewModel {
    @Published private(set) var viewState: HistoryViewState = .loading
    private let interactor: HistoryInteractor
    private let reducer = HistoryReducer()
    
    init(interactor: HistoryInteractor) {
        self.interactor = interactor
    }
    
    func send(_ event: HistoryViewEvent) async {
        switch event {
        case .load:
            await react(domainAction: .load)
        case let .deleteWorkoutHistory(workoutId, completionDate):
            await react(domainAction: .deleteWorkoutHistory(workoutId: workoutId,
                                                            completionDate: completionDate))
        case let .toggleDialog(dialog, isOpen):
            await react(domainAction: .toggleDialog(dialog: dialog, isOpen: isOpen))
        }
    }
}

// MARK: - Private

private extension HistoryViewModel {
    func updateViewState(_ viewState: HistoryViewState) async {
        await MainActor.run {
            self.viewState = viewState
        }
    }
    
    func react(domainAction: HistoryDomainAction) async {
        let domain = await interactor.interact(with: domainAction)
        let newViewState = reducer.reduce(domain)
        await updateViewState(newViewState)
    }
}
