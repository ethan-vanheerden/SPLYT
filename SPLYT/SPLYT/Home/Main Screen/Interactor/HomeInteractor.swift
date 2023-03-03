//
//  HomeInteractor.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 12/23/22.
//

import Foundation
import Core

// MARK: - Domain Actions

enum HomeDomainAction {
    case load
}

// MARK: - Domain Results

enum HomeDomainResult: Equatable {
    case error
    case loaded(HomeDomain)
}

// MARK: - Protocol

protocol HomeInteractorType {
    func interact(with: HomeDomainAction) async -> HomeDomainResult
}

// MARK: - Implementation

final class HomeInteractor: HomeInteractorType {
    private let service: HomeServiceType
    private var savedDomain: HomeDomain?
    
    init(service: HomeServiceType = HomeService()) {
        self.service = service
    }
    
    func interact(with action: HomeDomainAction) async -> HomeDomainResult {
        switch action {
        case .load:
            return await handleLoad()
        }
    }
}

// MARK: - Private

private extension HomeInteractor {
    func handleLoad() async -> HomeDomainResult {
        do {
            let workouts = try service.loadWorkouts()
            let domain = HomeDomain(workouts: workouts)
            
            // Update the saved domain
            savedDomain = domain
            return .loaded(domain)
        } catch {
            return .error
        }
    }
}
