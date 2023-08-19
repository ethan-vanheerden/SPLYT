//
//  LoginReducer.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 8/19/23.
//

import Foundation

struct LoginReducer {
    func reduce(_ domain: LoginDomainResult) -> LoginViewState {
        return .error
    }
}

// MARK: - Private

private extension LoginReducer {
    func getDisplay(domain: LoginDomain) -> LoginDisplay {
        return .init()
    }
}
