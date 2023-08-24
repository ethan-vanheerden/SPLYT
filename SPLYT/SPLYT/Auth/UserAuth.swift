//
//  Auth.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 8/16/23.
//

import Foundation
import FirebaseAuth

protocol UserAuthType {
    /// Creates a new user using the given email and password.
    /// - Parameters:
    ///   - email: The email of the user
    ///   - password: The password of the user
    /// - Returns: Whehter or not the operation was successful
    func createUser(email: String, password: String) async -> Bool
    
    /// Signs in the user and creates a new session with the given email and password.
    /// - Parameters:
    ///   - email: The email of the user
    ///   - password: The password of the user
    /// - Returns: Whether or not the operation was successful
    func login(email: String, password: String) async -> Bool
    
    /// Logs out the currently signed-in user.
    /// - Returns: Whehter or not the operation was successful
    func logout() -> Bool
    
    func isUserSignedIn(completion: @escaping (Bool) -> Void)
    
    /// Gets the current logged in user ID.
    /// - Returns: The ID if the user is currently logged in
    func getAuthToken() async -> String?
}

struct UserAuth: UserAuthType {
    func createUser(email: String, password: String) async -> Bool {
        do {
            try await Auth.auth().createUser(withEmail: email, password: password)
            return true
        } catch {
            return false
        }
    }
    
    func login(email: String, password: String) async -> Bool {
        do {
            try await Auth.auth().signIn(withEmail: email, password: password)
            return true
        } catch {
            return false
        }
    }
    
    func logout() -> Bool {
        do {
            try Auth.auth().signOut()
            return true
        } catch {
            return false
        }
    }
    
    func isUserSignedIn(completion: @escaping (Bool) -> Void) {
//        return Auth.auth().currentUser != nil
        Auth.auth().addStateDidChangeListener { auth, user in
            completion(user != nil)
        }
    }
    
    func getAuthToken() async -> String? {
        do {
            return try await Auth.auth().currentUser?.getIDToken()
        } catch {
            return nil
        }
    }
}
