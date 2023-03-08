//
//  SelectWorkoutNavigationRouter.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 3/5/23.
//

import Foundation
import Core

// MARK: - Navigation Events

enum SelectWorkoutNavigationEvent {
    case next
}

// MARK: - Router

final class SelectWorkoutNavigationRouter: NavigationRouter {
    weak var navigator: Navigator?
    
    func navigate(_ event: SelectWorkoutNavigationEvent) {
        switch event {
        case .next:
            handleNext()
        }
    }
}

// MARK: - Private

private extension SelectWorkoutNavigationRouter {
    func handleNext() {
        return // TODO
    }
}
