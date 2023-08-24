//
//  MainViewReducer.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 8/19/23.
//

import Foundation

struct MainViewReducer {
    func reduce(_ domain: MainViewDomainResult) -> MainViewState {
        switch domain {
//        case .notSignedIn:
//            return .notSignedin
//        case .signedIn:
//            return .signedIn
        case .loaded:
            return .loaded
        }
    }
}
