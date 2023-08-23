//
//  MainViewService.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 8/19/23.
//

import Foundation

// MARK: - Protocol

protocol MainViewServiceType {
    func isUserSignedIn() -> Bool
}

// MARK: - Implementation

struct MainViewService: MainViewServiceType {
    private let userAuth: UserAuthType
    
    init(userAuth: UserAuthType = UserAuth()) {
        self.userAuth = userAuth
    }
    
    func isUserSignedIn() -> Bool {
//        return userAuth.isUserSignedIn()
        return UserAuth().isUserSignedIn()
    }
}

