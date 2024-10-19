//
//  LoginDomain.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 8/19/23.
//

import Foundation

struct LoginDomain: Equatable {
    var email: String
    var password: String
    var birthday: Date
    var emailMessage: String
    var emailError: Bool
    var passwordMessage: String
    var passwordError: Bool
    var birthdayMessage: String
    var isCreateAccount: Bool
    var errorMessage: String?
    var canSubmit: Bool
    let termsURL: URL
}

// MARK: - Login Field

enum LoginField: Equatable {
    case email(String)
    case password(String)
    case birthday(Date)
}
