//
//  MockLoginService.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 8/28/23.
//

import Foundation
@testable import SPLYT

final class MockLoginService: LoginServiceType {
    var createUserSuccess = true
    func createUser(email: String, password: String) async -> Bool {
        return createUserSuccess
    }
    
    var loginSuccess = true
    func login(email: String, password: String) async -> Bool {
        return loginSuccess
    }
}
