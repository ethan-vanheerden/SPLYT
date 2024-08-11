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
    case deleteWorkout(id: String)
    case deletePlan(id: String)
    case toggleDialog(type: HomeDialog, isOpen: Bool)
}

// MARK: - Domain Results

enum HomeDomainResult: Equatable {
    case error
    case loaded(HomeDomain)
    case dialog(type: HomeDialog, domain: HomeDomain)
    case workoutInProgress
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
            return handleLoad()
        case let .deleteWorkout(id):
            return handleDeleteWorkout(id: id)
        case .deletePlan(let id):
            return handleDeletePlan(id: id)
        case let .toggleDialog(type, isOpen):
            return handleToggleDialog(type: type, isOpen: isOpen)
        }
    }
}

// MARK: - Private Handlers

private extension HomeInteractor {
    func handleLoad() -> HomeDomainResult {
        do {
            if service.isWorkoutInProgress() {
                return .workoutInProgress
            }
            
            let routines = try service.loadRoutines()
            let domain = HomeDomain(routines: routines)
            
            return updateDomain(domain)
        } catch {
            return .error
        }
    }
    
    func handleDeleteWorkout(id: String) -> HomeDomainResult {
        guard var domain = savedDomain else { return .error }
        
        do {
            domain.routines.workouts.removeValue(forKey: id)
            
            // Save the results
            try service.saveRoutines(domain.routines)
            // I'm not sure if we want this logic
//            try service.deleteWorkoutHistory(workoutId: id)
            
            return updateDomain(domain)
        } catch {
            return .error
        }
    }
    
    func handleDeletePlan(id: String) -> HomeDomainResult {
        guard var domain = savedDomain,
              let _ = domain.routines.plans[id] else { return .error }
        
        do {
            domain.routines.plans.removeValue(forKey: id)
            
            try service.saveRoutines(domain.routines)
            // We delete the workout history for each of the workouts in the plan
            // I'm not sure if we want this logic
//            for workout in plan.workouts {
//                try service.deleteWorkoutHistory(workoutId: workout.id)
//            }
            
            return updateDomain(domain)
        } catch {
            return .error
        }
    }
    
    func handleToggleDialog(type: HomeDialog, isOpen: Bool) -> HomeDomainResult {
        guard let domain = savedDomain else { return .error }
        
        return isOpen ? .dialog(type: type, domain: domain) : .loaded(domain)
    }
}

// MARK: - Other Private Helpers

private extension HomeInteractor {
    func updateDomain(_ newDomain: HomeDomain) -> HomeDomainResult {
        self.savedDomain = newDomain
        return .loaded(newDomain)
    }
}
