//
//  WorkoutsInteractor.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 12/23/22.
//

import Foundation
import Core

// MARK: - Domain Action

enum WorkoutsDomainAction {
    case loadWorkouts
}

// MARK: - Domain Results

enum WorkoutsDomainResult: Equatable {
    case error
    case loaded([String]) // TODO: this should actually be CreatedWorkouts and CreatedPlans
}

// MARK: - Protocol

protocol WorkoutsInteractorType {
    func interact(with: WorkoutsDomainAction) async -> WorkoutsDomainResult
}

// MARK: - Implementation

struct WorkoutsInteractor: WorkoutsInteractorType {
    func interact(with action: WorkoutsDomainAction) async -> WorkoutsDomainResult {
        switch action {
        case .loadWorkouts:
            return await handleLoadAvailableExercises()
        }
    }
}

// MARK: - Private

private extension WorkoutsInteractor {
    func handleLoadAvailableExercises() async -> WorkoutsDomainResult {
        return .loaded([])
    }
}
