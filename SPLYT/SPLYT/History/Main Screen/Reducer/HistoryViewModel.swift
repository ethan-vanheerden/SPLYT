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
        return
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
