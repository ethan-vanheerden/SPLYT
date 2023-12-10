//
//  Auth.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 8/16/23.
//

import Foundation
import FirebaseAuth
import UserAuth

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
