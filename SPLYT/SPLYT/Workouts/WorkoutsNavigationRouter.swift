//
//  WorkoutsNavigationRouter.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 12/20/22.
//

import Foundation
import Core
import UIKit

// MARK: - Navigation Events

enum WorkoutsNavigationEvent {
    case create
}

// MARK: - Router

final class WorkoutsNavigationRouter: NavigationRouter {
    weak var navigator: Navigator?
    
    func navigate(_ event: WorkoutsNavigationEvent) {
        switch event {
        case .create:
            handleCreate()
        }
    }
}

// MARK: - Private

private extension WorkoutsNavigationRouter {
    func handleCreate() {
        navigator?.present(UIViewController(), animated: true)
    }
}
