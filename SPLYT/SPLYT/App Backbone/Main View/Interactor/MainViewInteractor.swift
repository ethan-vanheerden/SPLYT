//
//  MainViewInteractor.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 8/19/23.
//

import Foundation
import FirebaseAuth

// MARK: - Domain Actions

enum MainViewDomainAction {
    case load
}

// MARK: - Domain Results

enum MainViewDomainResult: Equatable {
    case loaded
}

// MARK: - Interactor

final class MainViewInteractor {
    init() { }
    
    func interact(with action: MainViewDomainAction) async -> MainViewDomainResult {
        switch action {
        case .load:
            return handleLoad()
        }
    }
}

// MARK: - Private Handlers

private extension MainViewInteractor {
    func handleLoad() -> MainViewDomainResult {
        // Uncomment this code if you would like to log out the user
//        _ = UserAuth().logout()
        return .loaded
    }
}
