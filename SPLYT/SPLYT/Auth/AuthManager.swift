//
//  AuthManager.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 8/24/23.
//

import Foundation
import FirebaseAuth

// MARK: - Protocol

protocol AuthManagerType: ObservableObject {
    var isAuthenticated: Bool { get }
}

// MARK: - Implementation

final class AuthManager: AuthManagerType {
    @Published private(set) var isAuthenticated = true
    
    init() {
        Auth.auth().addStateDidChangeListener { [weak self] auth, user in
            self?.isAuthenticated = user != nil
            print("Signed in: \(user != nil)")
        }
    }
}
