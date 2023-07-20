//
//  WorkoutDetailsInteractor.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 7/20/23.
//

import Foundation

// MARK: - Domain Actions

enum WorkoutDetailsDomainAction {
    case load
}

// MARK: - Domain Results

enum WorkoutDetailsDomainResult {
    case error
    case loaded(WorkoutDetailsDomain)
}

// MARK: - Interactor

final class WorkoutDetailsInteractor {
    private let service: WorkoutDetailsServiceType
    private let historyId: String
    private var savedDomain: WorkoutDetailsDomain?
    
    init(service: WorkoutDetailsServiceType = WorkoutDetailsService(),
         historyId: String) {
        self.service = service
        self.historyId = historyId
    }
    
    func interact(with action: WorkoutDetailsDomainAction) async -> WorkoutDetailsDomainResult {
        return .error
    }
}

// MARK: - Private Handlers

private extension WorkoutDetailsInteractor {
    
}

// MARK: - Other Private Helpers

private extension WorkoutDetailsInteractor {
    
    /// Updates and saves the domain object.
    /// - Parameters:
    ///   - domain: The old domain to update
    /// - Returns: The loaded domain state after updating the domain object
    func updateDomain(domain: WorkoutDetailsDomain) -> WorkoutDetailsDomainResult {
        savedDomain = domain
        return .loaded(domain)
    }
}
