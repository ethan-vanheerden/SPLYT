//
//  DoWorkoutInteractor.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 5/17/23.
//

import Foundation
import ExerciseCore

// MARK: - Domain Actions

enum DoWorkoutDomainAction {
    case loadWorkout
    case stopCountdown
    case toggleRest(isResting: Bool)
}

// MARK: - Domain Results

enum DoWorkoutDomainResult {
    case error
    case loaded(DoWorkoutDomain)
}

// MARK: - Interactor

final class DoWorkoutInteractor {
    private let workoutId: String
    private let service: DoWorkoutServiceType
    private var savedDomain: DoWorkoutDomain?
    
    init(workoutId: String,
         service: DoWorkoutServiceType = DoWorkoutService()) {
        self.workoutId = workoutId
        self.service = service
    }
    
    func interact(with action: DoWorkoutDomainAction) async -> DoWorkoutDomainResult {
        switch action {
        case .loadWorkout:
            return handleLoadWorkout()
        case .stopCountdown:
            return handleStopCountdown()
        case .toggleRest(let isResting):
            return handleToggleRest(isResting: isResting)
        }
    }
}

// MARK: - Private Handlers

private extension DoWorkoutInteractor {
    
    func handleLoadWorkout() -> DoWorkoutDomainResult {
        do {
            let workout = try service.loadWorkout(id: workoutId)
            let domain = DoWorkoutDomain(workout: workout,
                                         inCountdown: true,
                                         isResting: false)
            return updateDomain(domain: domain)
        } catch {
            return .error
        }
    }
    
    func handleStopCountdown() -> DoWorkoutDomainResult {
        guard let domain = savedDomain else { return .error }
        domain.inCountdown = false
        return updateDomain(domain: domain)
    }
    
    func handleToggleRest(isResting: Bool) -> DoWorkoutDomainResult {
        guard let domain = savedDomain else { return .error }
        domain.isResting = isResting
        return updateDomain(domain: domain)
    }
}

// MARK: - Other Private Helpers

private extension DoWorkoutInteractor {
    
    /// Updates and saves the domain object.
    /// - Parameters:
    ///   - domain: The old domain to update
    ///   - workout: The workout to update
    /// - Returns: The loaded domain state after updating the domain object
    func updateDomain(domain: DoWorkoutDomain,
                      workout: Workout? = nil) -> DoWorkoutDomainResult {
        domain.workout = workout ?? domain.workout
        savedDomain = domain
        return .loaded(domain)
    }
}
