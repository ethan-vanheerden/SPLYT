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
    var emailMessage: String?
    var passwordMessage: String
    var passwordError: Bool
    var createAccount: Bool
    var passwordVisible: Bool
    var errorMessage: String?
    var canSubmit: Bool
}
