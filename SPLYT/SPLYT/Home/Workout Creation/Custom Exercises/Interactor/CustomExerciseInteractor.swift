//
//  CustomExerciseInteractor.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 5/22/24.
//

import Foundation
import ExerciseCore

// MARK: - Domain Actions

enum CustomExerciseDomainAction {
    case load
    case updateExerciseName(to: String)
    case updateMuscleWorked(muscle: MusclesWorked, isSelected: Bool)
    case submit
    case save
}

// MARK: - Domain Results

enum CustomExerciseDomainResult: Equatable {
    case error
    case loaded(CustomExerciseDomain)
    case exit(CustomExerciseDomain)
}

// MARK: - Interactor

final class CustomExerciseInteractor {
    private let exerciseName: String
    private let service: CustomExerciseServiceType
    private var savedDomain: CustomExerciseDomain?
    
    init(exerciseName: String, service: CustomExerciseServiceType) {
        self.exerciseName = exerciseName
        self.service = service
    }
    
    func interact(with action: CustomExerciseDomainAction) async -> CustomExerciseDomainResult {
        switch action {
        case .load:
            return handleLoad()
        case .updateExerciseName(let newName):
            return handleUpdateExerciseName(to: newName)
        case let .updateMuscleWorked(muscle, isSelected):
            return handleUpdateMuscleWorked(muscle: muscle, isSelected: isSelected)
        case .submit:
            return handleSubmit()
        case .save:
            return await handleSave()
        }
    }
}

// MARK: - Private Handlers

private extension CustomExerciseInteractor {
    func handleLoad() -> CustomExerciseDomainResult {
        let domain = CustomExerciseDomain(exerciseName: exerciseName,
                                          musclesWorked: createEmptyMusclesWorked(),
                                          canSave: false,
                                          isSaving: false)
        
        return updateDomain(domain: domain)
    }
    
    func handleUpdateExerciseName(to newName: String) -> CustomExerciseDomainResult {
        guard var domain = savedDomain else { return .error }
        
        domain.exerciseName = newName
        
        return updateDomain(domain: domain)
    }
    
    func handleUpdateMuscleWorked(muscle: MusclesWorked, isSelected: Bool) -> CustomExerciseDomainResult {
        guard var domain = savedDomain else { return .error }
        
        domain.musclesWorked[muscle] = isSelected
        
        return updateDomain(domain: domain)
    }
    
    func handleSubmit() -> CustomExerciseDomainResult {
        guard var domain = savedDomain else { return .error }
        
        domain.isSaving = true
        
        return updateDomain(domain: domain)
    }
    
    func handleSave() async -> CustomExerciseDomainResult {
        guard let domain = savedDomain else { return .error }
        
        do {
            let musclesWorked = domain.musclesWorked.filter { $0.value }.map { $0.key }
            try await service.createCustomExercise(exerciseName: domain.exerciseName,
                                                   musclesWorked: musclesWorked)
            
            return .exit(domain)
        } catch let error {
            return .error
        }
    }
}

// MARK: - Other Private Helpers

private extension CustomExerciseInteractor {
    
    /// Updates and saves the domain object.
    /// - Parameters:
    ///   - domain: The old domain to update
    /// - Returns: The loaded domain state after updating the domain object
    func updateDomain(domain: CustomExerciseDomain) -> CustomExerciseDomainResult {
        var domain = domain
        domain.canSave = !domain.exerciseName.isEmpty
        savedDomain = domain
        
        return .loaded(domain)
    }
    
    func createEmptyMusclesWorked() -> [MusclesWorked: Bool] {
        var musclesWorked = [MusclesWorked: Bool]()
        
        for muscle in MusclesWorked.allCases {
            musclesWorked[muscle] = false
        }
        
        return musclesWorked
    }
}
