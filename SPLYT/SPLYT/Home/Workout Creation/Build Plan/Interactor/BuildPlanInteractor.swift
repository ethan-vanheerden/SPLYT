//
//  BuildPlanInteractor.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 6/18/23.
//

import Foundation
import ExerciseCore

// MARK: - Domain Actions

enum BuildPlanDomainAction {
    case load
    case addWorkout(workout: Workout)
    case removeWorkout(workoutId: String)
    case savePlan
    case toggleDialog(dialog: BuildPlanDialog, isOpen: Bool)
}

// MARK: - Domain Results

enum BuildPlanDomainResult: Equatable {
    case error
    case loaded(BuildPlanDomain)
    case dialog(dialog: BuildPlanDialog, domain: BuildPlanDomain)
    case exit(BuildPlanDomain)
}

// MARK: - Interactor

final class BuildPlanInteractor {
    private let service: BuildPlanServiceType
    private let nameState: NameWorkoutNavigationState
    private let creationDate: Date
    private var savedDomain: BuildPlanDomain?
    
    init(service: BuildPlanServiceType = BuildPlanService(),
         nameState: NameWorkoutNavigationState,
         creationDate: Date = Date.now) {
        self.service = service
        self.nameState = nameState
        self.creationDate = creationDate
    }
    
    func interact(with action: BuildPlanDomainAction) async -> BuildPlanDomainResult {
        switch action {
        case .load:
            return handleLoad()
        case .addWorkout(let workout):
            return handleAddWorkout(workout: workout)
        case .removeWorkout(let workoutId):
            return handleRemoveWorkout(workoutId: workoutId)
        case .savePlan:
            return hanldeSavePlan()
        case let .toggleDialog(dialog, isOpen):
            return handleToggleDialog(dialog: dialog, isOpen: isOpen)
        }
    }
}

// MARK: - Private Handlers

private extension BuildPlanInteractor {
    func handleLoad() -> BuildPlanDomainResult {
        let id = WorkoutInteractor.getId(name: nameState.name,
                                         creationDate: creationDate)
        let newPlan = Plan(id: id,
                           name: nameState.name,
                           workouts: [],
                           createdAt: creationDate)
        let domain = BuildPlanDomain(builtPlan: newPlan,
                                     canSave: false)
        return updateDomain(domain: domain)
    }
    
    func handleAddWorkout(workout: Workout) -> BuildPlanDomainResult {
        guard let domain = savedDomain else { return .error }
        var workout = workout
        workout.planName = nameState.name
        domain.builtPlan.workouts.append(workout)
        
        return updateDomain(domain: domain)
    }
    
    func handleRemoveWorkout(workoutId: String) -> BuildPlanDomainResult {
        guard let domain = savedDomain else { return .error }
        domain.builtPlan.workouts.removeAll { $0.id == workoutId }
        
        return updateDomain(domain: domain)
    }
    
    func hanldeSavePlan() -> BuildPlanDomainResult {
        guard let domain = savedDomain else { return .error }
        do {
            try service.savePlan(domain.builtPlan)
            return .exit(domain)
        } catch {
            return .error
        }
    }
    
    func handleToggleDialog(dialog: BuildPlanDialog, isOpen: Bool) -> BuildPlanDomainResult {
        guard let domain = savedDomain else { return .error }
        
        return isOpen ? .dialog(dialog: dialog, domain: domain) : .loaded(domain)
    }
}

// MARK: - Other Private Helpers

private extension BuildPlanInteractor {
    
    /// Updates and saves the domain object.
    /// - Parameters:
    ///   - domain: The old domain to update
    /// - Returns: The loaded domain state after updating the domain object
    func updateDomain(domain: BuildPlanDomain) -> BuildPlanDomainResult {
        domain.canSave = !domain.builtPlan.workouts.isEmpty
        savedDomain = domain
        return .loaded(domain)
    }
}
