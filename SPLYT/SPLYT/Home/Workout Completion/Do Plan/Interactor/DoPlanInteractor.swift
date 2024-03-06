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
    case deleteWorkout(workoutId: String)
}

// MARK: - Domain Results

enum DoPlanDomainResult: Equatable {
    case error
    case loaded(DoPlanDomain)
}

// MARK: - Interactor

final class DoPlanInteractor {
    private let planId: String
    private let service: DoPlanServiceType
    private var savedDomain: DoPlanDomain?
    
    init(planId: String,
         service: DoPlanServiceType = DoPlanService()) {
        self.planId = planId
        self.service = service
    }
    
    func interact(with action: DoPlanDomainAction) async -> DoPlanDomainResult {
        switch action {
        case .load:
            return handleLoad()
        case .deleteWorkout(let workoutId):
            return handleDeleteWorkout(workoutId: workoutId)
        }
    }
}

// MARK: - Private Handlers

private extension DoPlanInteractor {
    func handleLoad() -> DoPlanDomainResult {
        do {
            let plan = try service.loadPlan(planId: planId)
            let domain = DoPlanDomain(plan: plan)
            
            return updateDomain(domain: domain)
        } catch {
            return .error
        }
    }
    
    func handleDeleteWorkout(workoutId: String) -> DoPlanDomainResult {
        guard var domain = savedDomain else { return .error }
        var plan = domain.plan
        
        do {
            try service.deleteWorkout(planId: plan.id, workoutId: workoutId)
        } catch {
            return .error
        }
        
        // Remove from local state copy too before update
        plan.workouts.removeAll { $0.id == workoutId }
        domain.plan = plan
        
        return updateDomain(domain: domain)
    }
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
