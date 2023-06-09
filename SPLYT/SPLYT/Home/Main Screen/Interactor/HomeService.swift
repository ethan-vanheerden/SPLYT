//
//  HomeServiceType.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 12/23/22.
//

import Foundation
import Caching
import ExerciseCore

// MARK: - Protocol

protocol HomeServiceType {
    func loadWorkouts() throws -> [String: CreatedWorkout]
    func saveWorkouts(_: [String: CreatedWorkout]) throws
}

// MARK: - Implementation

struct HomeService: HomeServiceType {
    private let workoutService: CreatedWorkoutsServiceType
    
    init(workoutService: CreatedWorkoutsServiceType = CreatedWorkoutsService()) {
        self.workoutService = workoutService
    }
    
    
    func loadWorkouts() throws -> [String: CreatedWorkout] {
        return try workoutService.loadWorkouts()
    }
    
    func saveWorkouts(_ workouts: [String: CreatedWorkout]) throws {
        try workoutService.saveWorkouts(workouts)
    }
}
