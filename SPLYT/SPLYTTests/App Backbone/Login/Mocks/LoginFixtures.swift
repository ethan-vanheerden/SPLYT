//
//  LoginFixtures.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 8/28/23.
//

import Foundation
@testable import SPLYT
import DesignSystem
import ExerciseCore


struct LoginFixtures {
    typealias WorkoutFixtures = WorkoutModelFixtures
    // MARK: - Domain
    
    static let email = "test@example.com"
    
    static let password = "password123"
    
    static let validEmailMessage = "Must be a valid email"
    
    static let validPasswordMessage = "Password must be at least 8 characters"
    
    static let birthdayMessage = "You must be at least 16 years old to use SPLYT"
    
    static let invalidEmail = "Invalid email"
    
    static let invalidPassword = "Invalid password"
    
    static let errorCreateAccount = """
Something went wrong. Double check your password or create an account if you don't have one.
"""
    static let errorOther = "Something went wrong. Please try again later."
    
    static let termsURL = URL(string: "https://ethan-vanheerden.github.io/splyt-terms/terms-conditions") ?? URL.applicationDirectory
    
    static let domain: LoginDomain = .init(email: "",
                                           password: "",
                                           birthday: WorkoutFixtures.dec_27_2022_1000,
                                           emailMessage: validEmailMessage,
                                           emailError: false,
                                           passwordMessage: validPasswordMessage,
                                           passwordError: false,
                                           birthdayMessage: birthdayMessage,
                                           birthdayError: false,
                                           isCreateAccount: false,
                                           canSubmit: false,
                                           termsURL: termsURL)
    
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
    
    static let createAccount = "Create Account"
    
    static let emailTextEntry: TextEntryViewState = .init(title: emailTitle,
                                                          includeCancelButton: false,
                                                          autoCapitalize: false)
    
    static let passwordTextEntry: TextEntryViewState = .init(title: passwordTitle,
                                                             entryType: .password,
                                                             includeCancelButton: false,
                                                             autoCapitalize: false)
    
    static let createAccountNavBar: NavigationBarViewState = .init(title: createAccount,
                                                                   backIconName: "xmark")
    
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
                                             submitButtonEnabled: false,
                                             createAccountNavBar: createAccountNavBar)
    
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
                                                   submitButtonEnabled: true,
                                                   createAccountNavBar: createAccountNavBar)
}
