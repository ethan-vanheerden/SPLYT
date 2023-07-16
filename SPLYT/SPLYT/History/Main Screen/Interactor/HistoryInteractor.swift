//
//  HistoryInteractor.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 7/16/23.
//

import Foundation

// MARK: - Domain Actions

enum HistoryDomainAction {
    case load
}

// MARK: - Domain Results

enum HistoryDomainResult {
    case error
    case loaded(HistoryDomain)
}

// MARK: - Interactor

final class HistoryInteractor {
    private let service: HistoryServiceType
    private var savedDomain: HistoryDomain?
    
    init(service: HistoryServiceType = HistoryService()) {
        self.service = service
    }
    
    func interact(with action: HistoryDomainAction) async -> HistoryDomainResult {
        return .error
    }
}

// MARK: - Private Handlers

private extension HistoryInteractor {
    
}

// MARK: - Other Private Helpers

private extension HistoryInteractor {
    
    /// Updates and saves the domain object.
    /// - Parameters:
    ///   - domain: The old domain to update
    /// - Returns: The loaded domain state after updating the domain object
    func updateDomain(domain: HistoryDomain) -> HistoryDomainResult {
        savedDomain = domain
        return .loaded(domain)
    }
}
