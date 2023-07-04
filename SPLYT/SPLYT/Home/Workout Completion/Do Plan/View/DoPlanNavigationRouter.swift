//
//  DoPlanNavigationRouter.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 7/4/23.
//

import Foundation
import Core

// MARK: - Navigation Events

enum DoPlanNavigationEvent {
    case exit
}

// MARK: - Router

final class DoPlanNavigationRouter: NavigationRouter {
    weak var navigator: Navigator?
    
    func navigate(_ event: DoPlanNavigationEvent) {
        return
    }
}

// MARK: - Private

private extension DoPlanNavigationRouter {
    
}
