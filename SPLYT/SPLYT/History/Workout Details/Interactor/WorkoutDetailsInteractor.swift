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
    case toggleGroupExpand(group: Int, isExpanded: Bool)
    case toggleDialog(dialog: WorkoutDetailsDialog, isOpen: Bool)
    case delete
}

// MARK: - Domain Results

enum WorkoutDetailsDomainResult: Equatable {
    case error
    case loaded(WorkoutDetailsDomain)
    case dialog(dialog: WorkoutDetailsDialog, domain: WorkoutDetailsDomain)
    case exit(WorkoutDetailsDomain)
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
        switch action {
        case .load:
            return handleLoad()
        case let .toggleGroupExpand(group, isExpanded):
            return handleToggleGroupExpand(group: group, isExpanded: isExpanded)
        case let .toggleDialog(dialog, isOpen):
            return handleToggleDialog(dialog: dialog, isOpen: isOpen)
        case .delete:
            return handleDelete()
        }
    }
}

// MARK: - Private Handlers

private extension WorkoutDetailsInteractor {
    func handleLoad() -> WorkoutDetailsDomainResult {
        do {
            let workout = try service.loadWorkout(historyId: historyId)
            let expandedGroups = workout.exerciseGroups.map { _ in return true }
            let domain = WorkoutDetailsDomain(workout: workout,
                                              expandedGroups: expandedGroups)
            
            return updateDomain(domain: domain)
        } catch {
            return .error
        }
    }
    
    func handleToggleGroupExpand(group: Int, isExpanded: Bool) -> WorkoutDetailsDomainResult {
        guard var domain = savedDomain,
              domain.expandedGroups.count > group else { return .error }
        domain.expandedGroups[group] = isExpanded
        return updateDomain(domain: domain)
    }
    
    func handleToggleDialog(dialog: WorkoutDetailsDialog, isOpen: Bool) -> WorkoutDetailsDomainResult {
        guard let domain = savedDomain else { return .error }
        
        return isOpen ? .dialog(dialog: dialog, domain: domain) : .loaded(domain)
    }
    
    func handleDelete() -> WorkoutDetailsDomainResult {
        guard let domain = savedDomain else { return .error }
        
        do {
            try service.deleteWorkoutHistory(historyId: historyId)
        } catch {
            return .error
        }
        
        return .exit(domain)
    }
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
