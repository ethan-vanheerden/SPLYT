//
//  WorkoutsViewModel.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 12/20/22.
//

import Foundation
import Core

// MARK: - Protocol

final class WorkoutsViewModel: ViewModel {
    @Published private(set) var viewState: WorkoutsViewState = .loading
    private let interactor: WorkoutsInteractorType
    private let reducer = WorkoutsViewStateReducer()
    
    init(interactor: WorkoutsInteractorType = WorkoutsInteractor()) {
        self.interactor = interactor
    }
    
    func send(_ event: WorkoutsViewEvent) async {
        switch event {
        case .load:
            await handleLoad()
        }
    }
    
}

// MARK: - Private

private extension WorkoutsViewModel {
    func updateViewState(_ viewState: WorkoutsViewState) async {
        await MainActor.run {
            self.viewState = viewState
        }
    }
    
    func handleLoad() async {
        let domain = await interactor.interact(with: .loadWorkouts)
        let viewState = reducer.reduce(domain)
        await updateViewState(viewState)
    }
}


// MARK: - Events

enum WorkoutsViewEvent {
    case load
}
