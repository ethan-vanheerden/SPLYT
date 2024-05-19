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
    func isWorkoutInProgress() -> Bool
//    func deleteWorkoutHistory(workoutId: String) throws
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
        let routines = try routineService.loadRoutines()
        return routines
    }
    
    func saveRoutines(_ routines: CreatedRoutines) throws {
        try routineService.saveRoutines(routines)
    }
    
    func isWorkoutInProgress() -> Bool {
        let cacheRequest = InProgressWorkoutCacheRequest()
        
        do {
            return try cacheInteractor.fileExists(request: cacheRequest)
        } catch {
            return false
        }
    }
}
