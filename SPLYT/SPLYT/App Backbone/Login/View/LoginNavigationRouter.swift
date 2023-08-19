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
    
}

// MARK: - Router

final class LoginNavigationRouter: NavigationRouter {
    weak var navigator: Navigator?
    
    func navigate(_ event: LoginNavigationEvent) {
        switch event {
            
        }
    }
}

// MARK: - Private

private extension LoginNavigationRouter {
    
}
