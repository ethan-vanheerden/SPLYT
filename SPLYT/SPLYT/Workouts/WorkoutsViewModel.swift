//
//  WorkoutsViewModel.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 12/20/22.
//

import Foundation
import Core

final class WorkoutsViewModel: ViewModel {
    @Published private(set) var viewState: WorkoutsViewState = .loading
    
    func send(_ event: WorkoutsViewEvent) async {
        switch event {
        case .load:
            await updateViewState(.main)
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
}


// MARK: - Events

enum WorkoutsViewEvent {
    case load
}
