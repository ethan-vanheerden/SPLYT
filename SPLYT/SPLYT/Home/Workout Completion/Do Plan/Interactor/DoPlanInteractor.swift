//
//  DoPlanInteractor.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 7/4/23.
//

import Foundation

// MARK: - Domain Actions

enum DoPlanDomainAction {
    case load
}

// MARK: - Domain Results

enum DoPlanDomainResult {
    case error
    case loaded(DoPlanDomain)
}

// MARK: - Interactor

final class DoPlanInteractor {
    private let service: DoPlanServiceType
    private var savedDomain: DoPlanDomain?
    
    init(service: DoPlanServiceType = DoPlanService()) {
        self.service = service
    }
    
    func interact(with action: DoPlanDomainAction) async -> DoPlanDomainResult {
        return .error
    }
}

// MARK: - Private Handlers

private extension DoPlanInteractor {
    
}

// MARK: - Other Private Helpers

private extension DoPlanInteractor {
    
    /// Updates and saves the domain object.
    /// - Parameters:
    ///   - domain: The old domain to update
    /// - Returns: The loaded domain state after updating the domain object
    func updateDomain(domain: DoPlanDomain) -> DoPlanDomainResult {
        savedDomain = domain
        return .loaded(domain)
    }
}
