//
//  WorkoutsService.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 12/23/22.
//

import Foundation
import Caching

protocol WorkoutsServiceType {
    func loadAvailableExercises() throws -> [AvailableExercise]
}

// MARK: - Implementation

struct WorkoutsService: WorkoutsServiceType {
    private let cacheInteractor: CacheInteractorType.Type
    
    init(cacheInteractor: CacheInteractorType.Type = CacheInteractor.self) {
        self.cacheInteractor = cacheInteractor
    }
    
    func loadAvailableExercises() throws -> [AvailableExercise] {
        let request = AvailableExercisesCacheRequest()
        let exercises = try cacheInteractor.load(with: request)
        return exercises
    }
}
