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
    private let userAuth: UserAuthType
    
    init(userAuth: UserAuthType = UserAuth()) {
        self.userAuth = userAuth
        userAuth.isUserSignedIn { [weak self] isSignedIn in
            self?.isAuthenticated = isSignedIn
        }
    }
}
