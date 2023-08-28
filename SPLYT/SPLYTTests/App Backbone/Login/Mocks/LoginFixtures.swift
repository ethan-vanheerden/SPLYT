//
//  LoginFixtures.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 8/28/23.
//

import Foundation
@testable import SPLYT
import DesignSystem

struct LoginFixtures {
    // MARK: - Domain
    
    static let email = "test@example.com"
    
    static let password = "password123"
    
    static let validEmailMessage = "Must be a valid email"
    
    static let validPasswordMessage = "Password must be at least 8 characters"
    
    static let invalidEmail = "Invalid email"
    
    static let invalidPassword = "Invalid password"
    
    static let errorCreateAccount = """
Something went wrong. Double check your password or create an account if you don't have one.
"""
    static let errorOther = "Something went wrong. Please try again later."
    
    static let domain: LoginDomain = .init(email: "",
                                           password: "",
                                           emailMessage: validEmailMessage,
                                           emailError: false,
                                           passwordMessage: validPasswordMessage,
                                           passwordError: false,
                                           isCreateAccount: false,
                                           canSubmit: false)
    
    static let domainFilled: LoginDomain = .init(email: email,
                                                 password: password,
                                                 emailMessage: validEmailMessage,
                                                 emailError: false,
                                                 passwordMessage: validPasswordMessage,
                                                 passwordError: false,
                                                 isCreateAccount: false,
                                                 canSubmit: true)
    
    // MARK: - View State
    
    static let emailTitle = "Email"
    
    static let passwordTitle = "Password"
    
    static let emailTextEntry: TextEntryViewState = .init(title: emailTitle,
                                                          includeCancelButton: false,
                                                          autoCapitalize: false)
    
    static let passwordTextEntry: TextEntryViewState = .init(title: passwordTitle,
                                                             entryType: .password,
                                                             includeCancelButton: false,
                                                             autoCapitalize: false)
    
    static let display: LoginDisplay = .init(email: "",
                                             password: "",
                                             emailTextEntry: emailTextEntry,
                                             emailMessage: validEmailMessage,
                                             emailMessageColor: .gray,
                                             passwordTextEntry: passwordTextEntry,
                                             passwordMessage: validPasswordMessage,
                                             passwordMessageColor: .gray,
                                             isCreateAccount: false,
                                             errorMessage: nil,
                                             submitButtonEnabled: false)
    
    static let displayFilled: LoginDisplay = .init(email: email,
                                                   password: password,
                                                   emailTextEntry: emailTextEntry,
                                                   emailMessage: validEmailMessage,
                                                   emailMessageColor: .gray,
                                                   passwordTextEntry: passwordTextEntry,
                                                   passwordMessage: validPasswordMessage,
                                                   passwordMessageColor: .gray,
                                                   isCreateAccount: false,
                                                   errorMessage: nil,
                                                   submitButtonEnabled: true)
}
