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
    case deleteWorkoutHistory(historyId: String)
    case toggleDialog(dialog: HistoryDialog, isOpen: Bool)
}

// MARK: - Domain Results

enum HistoryDomainResult {
    case error
    case loaded(HistoryDomain)
    case dialog(type: HistoryDialog, domain: HistoryDomain)
}

// MARK: - Interactor

final class HistoryInteractor {
    private let service: HistoryServiceType
    private var savedDomain: HistoryDomain?
    
    init(service: HistoryServiceType = HistoryService()) {
        self.service = service
    }
    
    func interact(with action: HistoryDomainAction) async -> HistoryDomainResult {
        switch action {
        case .load:
            return handleLoad()
        case .deleteWorkoutHistory(let historyId):
            return handleDeleteWorkoutHistory(historyId: historyId)
        case let .toggleDialog(dialog, isOpen):
            return handleToggleDialog(dialog: dialog, isOpen: isOpen)
        }
    }
}

// MARK: - Private Handlers

private extension HistoryInteractor {
    func handleLoad() -> HistoryDomainResult {
        do {
            let workoutHistory = try service.loadWorkoutHistory()
            let domain = HistoryDomain(workouts: workoutHistory)
            
            return updateDomain(domain: domain)
        } catch {
            return .error
        }
    }
    
    func handleDeleteWorkoutHistory(historyId: String) -> HistoryDomainResult {
        guard var domain = savedDomain else { return .error }
        
        do {
            let updatedWorkouts = try service.deleteWorkoutHistory(historyId: historyId)
            domain.workouts = updatedWorkouts
            
            return updateDomain(domain: domain)
        } catch {
            return .error
        }
    }
    
    func handleToggleDialog(dialog: HistoryDialog, isOpen: Bool) -> HistoryDomainResult {
        guard let domain = savedDomain else { return .error }
        
        return isOpen ? .dialog(type: dialog, domain: domain) : .loaded(domain)
    }
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
