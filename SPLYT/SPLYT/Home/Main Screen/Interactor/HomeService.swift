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
    func loadRoutines() throws -> CreatedRoutines
    func saveRoutines(_: CreatedRoutines) throws
    func deleteWorkoutHistory(workoutId: String) throws
}

// MARK: - Implementation

struct HomeService: HomeServiceType {
    private let cacheInteractor: CacheInteractorType
    private let routineService: CreatedRoutinesServiceType
    
    init(cacheInteractor: CacheInteractorType = CacheInteractor(),
         routineService: CreatedRoutinesServiceType = CreatedRoutinesService()) {
        self.cacheInteractor = cacheInteractor
        self.routineService = routineService
    }
    
    func loadRoutines() throws -> CreatedRoutines {
        return try routineService.loadRoutines()
    }
    
    func saveRoutines(_ routines: CreatedRoutines) throws {
        try routineService.saveRoutines(routines)
    }
    
    func deleteWorkoutHistory(workoutId: String) throws {
        let completedWorkoutsRequest = CompletedWorkoutsCacheRequest()
        
        if try cacheInteractor.fileExists(request: completedWorkoutsRequest) {
            var completedWorkouts = try cacheInteractor.load(request: completedWorkoutsRequest)
            completedWorkouts.removeAll { $0.id == workoutId }
            try cacheInteractor.save(request: completedWorkoutsRequest, data: completedWorkouts)
        }
    }
}
