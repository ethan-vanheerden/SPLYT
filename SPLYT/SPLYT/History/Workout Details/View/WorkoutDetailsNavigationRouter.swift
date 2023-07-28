//
//  WorkoutDetailsNavigationRouter.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 7/20/23.
//

import Foundation
import Core

// MARK: - Navigation Events

enum WorkoutDetailsNavigationEvent {
    case exit
}

// MARK: - Router

final class WorkoutDetailsNavigationRouter: NavigationRouter {
    weak var navigator: Navigator?
    
    func navigate(_ event: WorkoutDetailsNavigationEvent) {
        switch event {
        case .exit:
            handleExit()
        }
    }
}

// MARK: - Private

private extension WorkoutDetailsNavigationRouter {
    func handleExit() {
        navigator?.dismiss(animated: true)
    }
}

