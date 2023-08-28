//
//  LoginViewState.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 8/19/23.
//

import Foundation

enum LoginViewState: Equatable {
    case loading
    case error
    case loaded(LoginDisplay)
}
