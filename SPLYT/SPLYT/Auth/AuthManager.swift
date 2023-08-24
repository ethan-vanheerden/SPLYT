//
//  AuthManager.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 8/24/23.
//

import Foundation
import FirebaseAuth

final class AuthManager: ObservableObject {
    @Published private(set) var isAuthenticated = true
    
    init() {
        Auth.auth().addStateDidChangeListener { [weak self] auth, user in
            self?.isAuthenticated = user != nil
            print("Signed in: \(user != nil)")
        }
    }
}
