//
//  HistoryNavigationRouter.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 7/16/23.
//

import Foundation
import Core

// MARK: - Navigation Events

enum HistoryNavigationEvent {
    case selectWorkoutHistory(historyId: String)
}

// MARK: - Router

final class HistoryNavigationRouter: NavigationRouter {
    weak var navigator: Navigator?
    
    func navigate(_ event: HistoryNavigationEvent) {
        switch event {
        case .selectWorkoutHistory(let historyId):
            handleSelectWorkoutHistory(historyId: historyId)
        }
    }
}

// MARK: - Private

private extension HistoryNavigationRouter {
    func handleSelectWorkoutHistory(historyId: String) {
        
    }
}
