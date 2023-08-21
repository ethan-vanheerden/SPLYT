//
//  LoginNavigationRouter.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 8/19/23.
//

import Foundation
import Core

// MARK: - Navigation Events

enum LoginNavigationEvent {
    case goToHome
}

// MARK: - Router

final class LoginNavigationRouter: NavigationRouter {
    weak var navigator: Navigator?
    
    func navigate(_ event: LoginNavigationEvent) {
        switch event {
        case .goToHome:
            handleGoToHome()
        }
    }
}

// MARK: - Private

private extension LoginNavigationRouter {
    func handleGoToHome() {
        return
    }
}
