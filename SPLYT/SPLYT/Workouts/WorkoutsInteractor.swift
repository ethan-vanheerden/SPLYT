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
    case loadAvailableExercises
}

// MARK: - Domain Results

enum WorkoutsDomainResult {
    case error
    case loaded([AvailableExercise])
}

// MARK: - Protocol

protocol WorkoutsInteractorType {
    func interact(with: WorkoutsDomainAction) async -> WorkoutsDomainResult
}

// MARK: - Implementation

struct WorkoutsInteractor: WorkoutsInteractorType {
    func interact(with action: WorkoutsDomainAction) async -> WorkoutsDomainResult {
        switch action {
        case .loadAvailableExercises:
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
