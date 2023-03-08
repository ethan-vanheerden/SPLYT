//
//  BuildWorkoutNavigationRouter.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 3/4/23.
//

import Foundation
import Core

// MARK: - Navigation Events

enum BuildWorkoutNavigationEvent {
    case exit
}

// MARK: - Router

final class BuildWorkoutNavigationRouter: NavigationRouter {
    weak var navigator: Navigator?
    
    func navigate(_ event: BuildWorkoutNavigationEvent) {
        switch event {
        case .exit:
            handleExit()
        }
    }
}

// MARK: - Private

private extension BuildWorkoutNavigationRouter {
    func handleExit() -> Void {
        navigator?.dismissSelf(animated: true)
    }
}
