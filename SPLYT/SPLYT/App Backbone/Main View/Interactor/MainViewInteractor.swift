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
    private let service: MainViewServiceType
    
    init(service: MainViewServiceType = MainViewService()) {
        self.service = service
    }
    
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
        // TODO: remove
//        do {
//           try Auth.auth().signOut()
//        } catch {
//
//        }
        return .loaded
    }
}
