//
//  LoginService.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 8/19/23.
//

import Foundation

// MARK: - Protocol

protocol LoginServiceType {
    func createUser(email: String, password: String) async -> Bool
    func login(email: String, password: String) async -> Bool
}

// MARK: - Implementation

struct LoginService: LoginServiceType {
    private let userAuth: UserAuthType
    
    init(userAuth: UserAuthType = UserAuth()) {
        self.userAuth = userAuth
    }
    
    func createUser(email: String, password: String) async -> Bool {
        return await userAuth.createUser(email: email, password: password)
    }
    
    func login(email: String, password: String) async -> Bool {
        return await userAuth.login(email: email, password: password)
    }
}
