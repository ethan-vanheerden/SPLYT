//
//  CustomExerciseService.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 5/22/24.
//

import Foundation
import Networking
import Caching
import ExerciseCore

// MARK: - Protocol

protocol CustomExerciseServiceType {
    func createCustomExercise(exerciseName: String, musclesWorked: [MusclesWorked]) async throws
}

// MARK: - Implementation

struct CustomExerciseService: CustomExerciseServiceType {
    private let cacheInteractor: CacheInteractorType
    private let apiInteractor: APIInteractorType.Type
    
    init(cacheInteractor: CacheInteractorType = CacheInteractor(),
         apiInteractor: APIInteractorType.Type = APIInteractor.self) {
        self.cacheInteractor = cacheInteractor
        self.apiInteractor = apiInteractor
    }
    
    func createCustomExercise(exerciseName: String, musclesWorked: [MusclesWorked]) async throws {
        let request = CreateCustomExerciseRequest(requestBody: .init(name: exerciseName,
                                                                     musclesWorked: musclesWorked))
        
        let exercise = try await apiInteractor.performRequest(with: request)
        
        // Need to save the custom exercise to the user's cache as well
        let cacheRequest = AvailableExercisesCacheRequest()
        var cachedExercises = try cacheInteractor.load(request: cacheRequest)
        
        cachedExercises[exercise.id] = exercise
        try cacheInteractor.save(request: cacheRequest, data: cachedExercises)
    }
}
