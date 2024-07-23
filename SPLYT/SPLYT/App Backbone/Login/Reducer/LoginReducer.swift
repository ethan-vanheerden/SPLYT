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
        }
    }
}

// MARK: - Private

private extension LoginReducer {
    func getDisplay(domain: LoginDomain) -> LoginDisplay {
        let emailMessageColor = getMessageColor(isError: domain.emailError)
        let passwordMessageColor = getMessageColor(isError: domain.passwordError)
        let birthdayMessageColor = getMessageColor(isError: domain.birthdayError)
        
        let display = LoginDisplay(email: domain.email,
                                   password: domain.password,
                                   birthday: domain.birthday,
                                   emailTextEntry: emailTextEntry,
                                   emailMessage: domain.emailMessage,
                                   emailMessageColor: emailMessageColor,
                                   passwordTextEntry: passwordtextEntry,
                                   passwordMessage: domain.passwordMessage,
                                   passwordMessageColor: passwordMessageColor,
                                   birthdayMessage: domain.birthdayMessage,
                                   birthdayMessageColor: birthdayMessageColor,
                                   isCreateAccount: domain.isCreateAccount,
                                   errorMessage: domain.errorMessage,
                                   submitButtonEnabled: domain.canSubmit,
                                   createAccountNavBar: createAccountNavBar,
                                   termsURL: domain.termsURL)
        
        return display
    }
    
    var emailTextEntry: TextEntryViewState {
        return .init(title: Strings.email,
                     includeCancelButton: false,
                     capitalization: .never,
                     disableAutoCorrect: true)
    }
    
    var passwordtextEntry: TextEntryViewState {
        return .init(title: Strings.password,
                     entryType: .password,
                     includeCancelButton: false,
                     capitalization: .never)
    }
    
    func getMessageColor(isError: Bool) -> SplytColor {
        return isError ? .red : .gray
    }
    
    var createAccountNavBar: NavigationBarViewState {
        return .init(title: Strings.createAccount,
                     backIconName: "xmark")
    }
}

// MARK: - Strings

fileprivate struct Strings {
    static let email = "Email"
    static let password = "Password"
    static let createAccount = "Create Account"
}
