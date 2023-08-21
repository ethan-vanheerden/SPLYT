//
//  LoginReducer.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 8/19/23.
//

import Foundation
import DesignSystem

struct LoginReducer {
    func reduce(_ domain: LoginDomainResult) -> LoginViewState {
        switch domain {
        case .error:
            return .error
        case .loaded(let domain):
            let display = getDisplay(domain: domain)
            return .loaded(display)
        case .loggedIn:
            return .loggedIn
        }
    }
}

// MARK: - Private

private extension LoginReducer {
    func getDisplay(domain: LoginDomain) -> LoginDisplay {
        let passwordMessageColor = getPasswordMessageColor(isError: domain.passwordError)
        
        let display = LoginDisplay(email: domain.email,
                                   password: domain.password,
                                   emailTextEntry: emailTextEntry,
                                   emailMessage: domain.emailMessage,
                                   passwordTextEntry: passwordtextEntry,
                                   passwordMessage: domain.passwordMessage,
                                   passwordMessageColor: passwordMessageColor,
                                   createAccount: domain.createAccount,
                                   passwordVisible: domain.passwordVisible,
                                   errorMessage: domain.errorMessage,
                                   submitButtonEnabled: domain.canSubmit)
        
        return display
    }
    
    var emailTextEntry: TextEntryViewState {
        return .init(title: Strings.email)
    }
    
    var passwordtextEntry: TextEntryViewState {
        return .init(title: Strings.password)
    }
    
    func getPasswordMessageColor(isError: Bool) -> SplytColor {
        return isError ? .red : .gray
    }
}

// MARK: - Strings

fileprivate struct Strings {
    static let email = "Email"
    static let password = "Password"
}
