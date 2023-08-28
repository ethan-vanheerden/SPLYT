//
//  LoginDisplay.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 8/19/23.
//

import Foundation
import DesignSystem

struct LoginDisplay: Equatable {
    let email: String
    let password: String
    let emailTextEntry: TextEntryViewState
    let emailMessage: String
    let emailMessageColor: SplytColor
    let passwordTextEntry: TextEntryViewState
    let passwordMessage: String
    let passwordMessageColor: SplytColor
    let isCreateAccount: Bool
    let errorMessage: String?
    let submitButtonEnabled: Bool
    let createAccountNavBar: NavigationBarViewState
}
