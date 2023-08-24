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
//        return UserAuth().isUserSignedIn()
        return false
    }
}

/*
 
 TODO:
 
 make an auth observed object with the authstatedidchange listener to update a state isSignedIn property
 once the user is signed in.
 
 Either the view or the view model can have this observed/published property so that the view can show the login view
 if the user is not logged in
 */
