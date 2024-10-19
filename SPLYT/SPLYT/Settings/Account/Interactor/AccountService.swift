//
//  AccountService.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 10/17/24.
//

import UserAuth
import Networking

// MARK: - AccountServicing

protocol AccountServicing {
    /// Signs out the current user.
    /// - Returns: Whether the operation was successful or not
    func signOut() -> Bool
    
    /// Deletes the currently signed in user.
    /// - Returns: Whether the operation was successful or not
    func deleteUser() async -> Bool
}

// MARK: - AccountService

struct AccountService: AccountServicing {
    private let userAuth: UserAuthType
    private let apiInteractor: APIInteractorType.Type
    
    init(userAuth: UserAuthType = UserAuth(),
         apiInteractor: APIInteractorType.Type = APIInteractor.self) {
        self.userAuth = userAuth
        self.apiInteractor = apiInteractor
    }
    
    func signOut() -> Bool {
        return userAuth.logout()
    }
    
    func deleteUser() async -> Bool {
        let request = DeleteAccountRequest(userAuth: userAuth)
        
        do {
            let response = try await apiInteractor.performRequest(with: request)
            
            return response.wasSuccessful
        } catch {
            return false
        }
    }
}
