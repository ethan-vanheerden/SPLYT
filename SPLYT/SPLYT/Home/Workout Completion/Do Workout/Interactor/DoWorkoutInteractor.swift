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
    case toggleGroupExpand(group: Int, isExpanded: Bool)
    case completeGroup(group: Int)
    case addSet(group: Int)
    case removeSet(group: Int)
    case updateSet(group: Int, exerciseIndex: Int, setIndex: Int, with: SetInput, forModifier: Bool)
    case usePreviousInput(group: Int, exerciseIndex: Int, setIndex: Int, forModifier: Bool)
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
        case let .toggleGroupExpand(group, isExpanded):
            return handleToggleGroupExpand(group: group, isExpanded: isExpanded)
        case .completeGroup(let group):
            return handleCompleteGroup(group: group)
        case .addSet(let group):
            return handleAddSet(group: group)
        case .removeSet(let group):
            return handleRemoveSet(group: group)
        case let .updateSet(group, exerciseIndex, setIndex, newInput, forModifier):
            return handleUpdateSet(group: group,
                                   exercieIndex: exerciseIndex,
                                   setIndex: setIndex,
                                   with: newInput,
                                   forModifier: forModifier)
        case let .usePreviousInput(group, exerciseIndex, setIndex, forModifier):
            return handleUsePreviousInput(group: group,
                                          exerciseIndex: exerciseIndex,
                                          setIndex: setIndex,
                                          forModifier: forModifier)
        }
    }
}

// MARK: - Private Handlers

private extension DoWorkoutInteractor {
    
    func handleLoadWorkout() -> DoWorkoutDomainResult {
        do {
            let loadedWorkout = try service.loadWorkout(id: workoutId)
            let workout = createPlaceholders(previousWorkout: loadedWorkout)
            let expandedGroups = getStartingExpandedGroups(groups: workout.exerciseGroups)
            let completedGroups = workout.exerciseGroups.map { _ in return false }
            
            let domain = DoWorkoutDomain(workout: workout,
                                         inCountdown: true,
                                         isResting: false,
                                         expandedGroups: expandedGroups,
                                         completedGroups: completedGroups,
                                         fractionCompleted: 0)
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
    
    func handleToggleGroupExpand(group: Int, isExpanded: Bool) -> DoWorkoutDomainResult {
        guard let domain = savedDomain else { return .error }
        domain.expandedGroups[group] = isExpanded
        return updateDomain(domain: domain)
    }
    
    func handleCompleteGroup(group: Int) -> DoWorkoutDomainResult {
        guard let domain = savedDomain else { return .error }
        domain.completedGroups[group] = true
        domain.expandedGroups[group] = false // Close the completed group
        
        // Expand the next incomplete group
        var nextGroupIndex = group + 1
        while domain.expandedGroups.count > nextGroupIndex {
            if !domain.completedGroups[nextGroupIndex] {
                domain.expandedGroups[nextGroupIndex] = true
                break
            }
            nextGroupIndex += 1
        }
        
        // Update the fraction completed
        domain.fractionCompleted = getFractionCompleted(completedGroups: domain.completedGroups)
        
        return updateDomain(domain: domain)
    }
    
    func handleAddSet(group: Int) -> DoWorkoutDomainResult {
        guard let domain = savedDomain else { return .error }
        let updatedGroups = WorkoutInteractor.addSet(group: group,
                                                     groups: domain.workout.exerciseGroups)
        domain.workout.exerciseGroups = updatedGroups
        
        return updateDomain(domain: domain)
    }
    
    func handleRemoveSet(group: Int) -> DoWorkoutDomainResult {
        guard let domain = savedDomain else { return .error }
        let updatedGroups = WorkoutInteractor.removeSet(group: group,
                                                        groups: domain.workout.exerciseGroups)
        domain.workout.exerciseGroups = updatedGroups
        
        return updateDomain(domain: domain)
    }
    
    func handleUpdateSet(group: Int,
                         exercieIndex: Int,
                         setIndex: Int,
                         with newInput: SetInput,
                         forModifier: Bool) -> DoWorkoutDomainResult {
        guard let domain = savedDomain else { return .error }
        let updatedGroups = WorkoutInteractor.updateSet(groupIndex: group,
                                                        groups: domain.workout.exerciseGroups,
                                                        exerciseIndex: exercieIndex,
                                                        setIndex: setIndex,
                                                        newSetInput: forModifier ? nil : newInput,
                                                        newModifierInput: forModifier ? newInput : nil)
        domain.workout.exerciseGroups = updatedGroups
        
        return updateDomain(domain: domain)
    }
    
    func handleUsePreviousInput(group: Int,
                                exerciseIndex: Int,
                                setIndex: Int,
                                forModifier: Bool) -> DoWorkoutDomainResult {
        guard let domain = savedDomain else { return .error }
        let targetSet = domain.workout.exerciseGroups[group].exercises[exerciseIndex].sets[setIndex]
        let oldInput: SetInput? = forModifier ? targetSet.modifier?.input : targetSet.input
        let newInput = oldInput?.placeholderInput
        
        let updatedGroups = WorkoutInteractor.updateSet(groupIndex: group,
                                                        groups: domain.workout.exerciseGroups,
                                                        exerciseIndex: exerciseIndex,
                                                        setIndex: setIndex,
                                                        newSetInput: forModifier ? nil : newInput,
                                                        newModifierInput: forModifier ? newInput : nil)
        domain.workout.exerciseGroups = updatedGroups
        
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
    func updateDomain(domain: DoWorkoutDomain) -> DoWorkoutDomainResult {
        savedDomain = domain
        return .loaded(domain)
    }
    
    
    /// Creates a new workout where all the sets in the new workout have placeholders which are the inputs of the
    /// old workout. This is so that users can see what they did last time easily.
    /// - Parameter previousWorkout: The last workout (of the same one) which was done by the user. Note: if this is the first time the user is
    ///                              doing the workout, this will be the object that was created when they built their workout.
    /// - Returns: A workout where the inputs are the given workout's placeholders
    func createPlaceholders(previousWorkout: Workout) -> Workout {
        var workout = previousWorkout
        var newGroups = workout.exerciseGroups
        // Triple for-loop but ok
        for (groupIndex, group) in previousWorkout.exerciseGroups.enumerated() {
            for (exerciseIndex, exercise) in group.exercises.enumerated() {
                for (setIndex, set) in exercise.sets.enumerated() {
                    let newInput = createSetPlaceholder(setInput: set.input)
                    let newModifer = createModifierPlaceholder(modifier: set.modifier)
                    let newSet = Set(input: newInput,
                                     modifier: newModifer)
                    newGroups[groupIndex].exercises[exerciseIndex].sets[setIndex] = newSet
                }
            }
        }
        workout.exerciseGroups = newGroups
        
        return workout
    }
    
    /// Determines which group headers are expanded upon workout start (just the first group should be expanded).
    /// - Parameter groups: The exercise groups we need a header for
    /// - Returns: A list of booleans, where true indicates the header for the corresponding group index should be expanded,
    ///             and false if it should be collapsed
    func getStartingExpandedGroups(groups: [ExerciseGroup]) -> [Bool] {
        var result: [Bool] = groups.map { _ in return false }
        result[0] = true // Mark the first group as expanded
        return result
    }
    
    /// Determines the fraction of the workout completed based on which groups are completed.
    /// - Parameter completedGroups: List which determines which group indices are completed
    /// - Returns: The fraction of the workout that is completed
    func getFractionCompleted(completedGroups: [Bool]) -> Double {
        let numTrue: Double = completedGroups.reduce(0) { partialResult, isCompleted in
            isCompleted ? partialResult + 1 : partialResult
        }
        
        return numTrue / Double(completedGroups.count)
    }
    
    func createSetPlaceholder(setInput: SetInput) -> SetInput {
        switch setInput {
        case .repsWeight(let input):
            let newInput = RepsWeightInput(weightPlaceholder: input.weight ?? input.weightPlaceholder,
                                           repsPlaceholder: input.reps ?? input.repsPlaceholder)
            return .repsWeight(input: newInput)
        case .repsOnly(let input):
            let newInput = RepsOnlyInput(placeholder: input.reps ?? input.placeholder)
            return .repsOnly(input: newInput)
        case .time(let input):
            let newInput = TimeInput(placeholder: input.placeholder ?? input.seconds)
            return .time(input: newInput)
        }
    }
    
    func createModifierPlaceholder(modifier: SetModifier?) -> SetModifier? {
        guard let modifier = modifier else { return nil }
        switch modifier {
        case .dropSet(let input):
            return .dropSet(input: createSetPlaceholder(setInput: input))
        case .restPause(let input):
            return .restPause(input: createSetPlaceholder(setInput: input))
        case .eccentric:
            return .eccentric
        }
    }
}
