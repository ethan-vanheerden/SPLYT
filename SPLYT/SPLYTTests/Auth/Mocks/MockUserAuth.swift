//
//  MockUserAuth.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 8/28/23.
//

@testable import SPLYT

final class MockUserAuth: UserAuthType {
    private(set) var signedIn = true
    
    var createUserSuccess = true
    func createUser(email: String, password: String) async -> Bool {
        signedIn = createUserSuccess
        return createUserSuccess
    }
    
    var loginSuccess = true
    func login(email: String, password: String) async -> Bool {
        signedIn = loginSuccess
        return loginSuccess
    }
    
    var logoutSuccess = true
    @discardableResult
    func logout() -> Bool {
        signedIn = logoutSuccess ? false : signedIn
        return logoutSuccess
    }
    
    func isUserSignedIn(completion: @escaping (Bool) -> Void) {
        completion(signedIn)
    }
    
    var stubAuthToken = "token"
    func getAuthToken() async -> String? {
        return stubAuthToken
    }
}
