//
//  DoWorkoutInteractor.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 5/17/23.
//

import Foundation
import ExerciseCore
import Caching

// MARK: - Domain Actions

enum DoWorkoutDomainAction {
    case loadWorkout
    case stopCountdown
    case startRest(restSeconds: Int)
    case stopRest(manuallyStopped: Bool)
    case toggleGroupExpand(group: Int, isExpanded: Bool)
    case completeGroup(group: Int)
    case addSet(group: Int)
    case removeSet(group: Int)
    case updateSet(group: Int, exerciseIndex: Int, setIndex: Int, with: SetInput, forModifier: Bool)
    case usePreviousInput(group: Int, exerciseIndex: Int, setIndex: Int, forModifier: Bool)
    case toggleDialog(dialog: DoWorkoutDialog, isOpen: Bool)
    case saveWorkout
    case cacheWorkout(secondsElapsed: Int)
    case pauseRest
    case resumeRest(restSeconds: Int)
    case markExerciseLoading(group: Int, exerciseIndex: Int) // TODO: Combine would be much better to do for this flow
    case replaceExercise(group: Int, exerciseIndex: Int, newExerciseId: String)
    case deleteExercise(group: Int, exerciseIndex: Int)
    case addModifier(group: Int, exerciseIndex: Int, setIndex: Int, modifier: SetModifier)
    case removeModifier(group: Int, exerciseIndex: Int, setIndex: Int)
    case addExercises(newExerciseIds: [String])
}

// MARK: - Domain Results

enum DoWorkoutDomainResult: Equatable {
    case error
    case loaded(DoWorkoutDomain)
    case dialog(dialog: DoWorkoutDialog, domain: DoWorkoutDomain)
    case exit(DoWorkoutDomain)
}

// MARK: - Interactor

final class DoWorkoutInteractor {
    private var workoutId: String?
    private let service: DoWorkoutServiceType
    private var planId: String?
    private var savedDomain: DoWorkoutDomain?
    
    init(workoutId: String,
         service: DoWorkoutServiceType = DoWorkoutService(),
         planId: String? = nil) {
        self.workoutId = workoutId
        self.service = service
        self.planId = planId
    }
    
    // Initializer for loading from cache
    init(service: DoWorkoutServiceType = DoWorkoutService()) {
        self.service = service
        self.workoutId = nil
        self.planId = nil
    }
    
    func interact(with action: DoWorkoutDomainAction) async -> DoWorkoutDomainResult {
        switch action {
        case .loadWorkout:
            return handleLoadWorkout()
        case .stopCountdown:
            return handleStopCountdown()
        case .startRest(let restSeconds):
            return await handleStartRest(restSeconds: restSeconds)
        case .stopRest(let manuallyStopped):
            return handleStopRest(manuallyStopped: manuallyStopped)
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
        case let .toggleDialog(dialog, isOpen):
            return handleToggleDialog(dialog: dialog, isOpen: isOpen)
        case .saveWorkout:
            return handleSaveWorkout()
        case .cacheWorkout(let secondsElapsed):
            return handleCacheWorkout(secondsElapsed: secondsElapsed)
        case .pauseRest:
            return await handleTogglePauseRest(isPaused: true, restSeconds: nil)
        case .resumeRest(let restSeconds):
            return await handleTogglePauseRest(isPaused: false, restSeconds: restSeconds)
        case let .markExerciseLoading(group, exerciseIndex):
            return handleMarkExerciseLoading(group: group, exerciseIndex: exerciseIndex)
        case let .replaceExercise(group, exerciseIndex, newExerciseId):
            return await handleReplaceExercise(group: group,
                                               exerciseIndex: exerciseIndex,
                                               newExerciseId: newExerciseId)
        case let .deleteExercise(group, exerciseIndex):
            return handleDeleteExercise(group: group, exerciseIndex: exerciseIndex)
        case let .addModifier(group, exerciseIndex, setIndex, modifier):
            return handleAddModifier(group: group,
                                     exerciseIndex: exerciseIndex,
                                     setIndex: setIndex,
                                     modifier: modifier)
        case let .removeModifier(group, exerciseIndex, setIndex):
            return handleRemoveModifier(group: group,
                                        exerciseIndex: exerciseIndex,
                                        setIndex: setIndex)
        case .addExercises(let exerciseIds):
            return await handleAddExercises(newExerciseIds: exerciseIds)
        }
    }
}

// MARK: - Private Handlers

private extension DoWorkoutInteractor {
    func handleLoadWorkout() -> DoWorkoutDomainResult {
        do {
            let restPresets = service.loadRestPresets()
            
            guard let workoutId = workoutId else {
                let inProgressDomain = try getInProgressWorkoutDomain(restPresets: restPresets)
                return updateDomain(domain: inProgressDomain)
            }
            
            let loadedWorkout = try service.loadWorkout(workoutId: workoutId,
                                                        planId: planId)
            let workout = createPlaceholders(previousWorkout: loadedWorkout)
            let expandedGroups = getStartingExpandedGroups(groups: workout.exerciseGroups)
            let completedGroups = workout.exerciseGroups.map { _ in return false }
            let fractionCompleted: Double = 0
            
            let domain = DoWorkoutDomain(workout: workout,
                                         inCountdown: true,
                                         isResting: false,
                                         expandedGroups: expandedGroups,
                                         completedGroups: completedGroups,
                                         fractionCompleted: fractionCompleted,
                                         restPresets: restPresets,
                                         canDeleteExercise: canDeleteExercise(workout: workout))
            
            return updateDomain(domain: domain)
        } catch {
            return .error
        }
    }
    
    func handleStopCountdown() -> DoWorkoutDomainResult {
        guard var domain = savedDomain else { return .error }
        
        domain.inCountdown = false
        
        let inProgressWorkout = InProgressWorkout(secondsElapsed: 0,
                                                  workout: domain.workout,
                                                  planId: planId,
                                                  expandedGroups: domain.expandedGroups,
                                                  completedGroups: domain.completedGroups,
                                                  fractionCompleted: domain.fractionCompleted)
        service.saveInProgressWorkout(inProgressWorkout)
        
        return updateDomain(domain: domain)
    }
    
    func handleStartRest(restSeconds: Int) async -> DoWorkoutDomainResult {
        guard var domain = savedDomain else { return .error }
        
        domain.isResting = true
        
        if let workoutId = workoutId {
            do {
                try await service.scheduleRestNotifcation(workoutId: workoutId,
                                                          after: restSeconds)
            } catch { }
        }
        
        return updateDomain(domain: domain)
    }
    
    func handleStopRest(manuallyStopped: Bool) -> DoWorkoutDomainResult {
        guard var domain = savedDomain else { return .error }
        
        domain.isResting = false
        
        if !manuallyStopped {
            do {
                try service.playRestTimerSound()
            } catch { }
        }
        
        if let workoutId = workoutId,
           manuallyStopped {
            service.deleteRestNotification(workoutId: workoutId)
        }
        
        return updateDomain(domain: domain)
    }
    
    func handleToggleGroupExpand(group: Int, isExpanded: Bool) -> DoWorkoutDomainResult {
        guard var domain = savedDomain else { return .error }
        domain.expandedGroups[group] = isExpanded
        return updateDomain(domain: domain)
    }
    
    func handleCompleteGroup(group: Int) -> DoWorkoutDomainResult {
        guard var domain = savedDomain else { return .error }
        domain.completedGroups[group] = true
        domain.expandedGroups[group] = false // Close the completed group
        
        let nextExpandedGroupIndex = getNextIncompleteGroup(completedGroups: domain.completedGroups,
                                                            startingAfter: group)
        
        if let nextExpandedGroupIndex = nextExpandedGroupIndex {
            domain.expandedGroups[nextExpandedGroupIndex] = true
        }
        
        // Update the fraction completed
        domain.fractionCompleted = getFractionCompleted(completedGroups: domain.completedGroups)
        
        // If workout is complete, show the finish dialog
        if domain.fractionCompleted == 1 {
            _ = updateDomain(domain: domain)
            return .dialog(dialog: .finishWorkout, domain: domain)
        }
        
        return updateDomain(domain: domain)
    }
    
    func handleAddSet(group: Int) -> DoWorkoutDomainResult {
        guard var domain = savedDomain else { return .error }
        let updatedGroups = WorkoutInteractor.addSet(group: group,
                                                     groups: domain.workout.exerciseGroups)
        domain.workout.exerciseGroups = updatedGroups
        
        return updateDomain(domain: domain)
    }
    
    func handleRemoveSet(group: Int) -> DoWorkoutDomainResult {
        guard var domain = savedDomain else { return .error }
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
        guard var domain = savedDomain else { return .error }
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
        guard var domain = savedDomain else { return .error }
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
    
    func handleToggleDialog(dialog: DoWorkoutDialog, isOpen: Bool) -> DoWorkoutDomainResult {
        guard let domain = savedDomain else { return .error }
        
        return isOpen ? .dialog(dialog: dialog, domain: domain) : .loaded(domain)
    }
    
    func handleSaveWorkout() -> DoWorkoutDomainResult {
        guard var domain = savedDomain else { return .error }
        do {
            let historyId = try service.saveWorkout(workout: domain.workout,
                                                    planId: planId,
                                                    completionDate: Date.now)
            domain.workoutDetailsId = historyId
            
            try service.deleteInProgressWorkoutCache()
            
            if let workoutId = workoutId {
                // Delete this in case there is one scheduled
                service.deleteRestNotification(workoutId: workoutId)
            }
            
            return .exit(domain)
        } catch {
            return .error
        }
    }
    
    func handleCacheWorkout(secondsElapsed: Int) -> DoWorkoutDomainResult {
        guard let domain = savedDomain else { return .error }
        let inProgressWorkout = InProgressWorkout(secondsElapsed: secondsElapsed,
                                                  workout: domain.workout,
                                                  planId: planId,
                                                  expandedGroups: domain.expandedGroups,
                                                  completedGroups: domain.completedGroups,
                                                  fractionCompleted: domain.fractionCompleted)
        
        service.saveInProgressWorkout(inProgressWorkout)
        
        return .loaded(domain)
    }
    
    func handleTogglePauseRest(isPaused: Bool, restSeconds: Int?) async -> DoWorkoutDomainResult {
        guard let domain = savedDomain else { return .error }
        
        if let workoutId = workoutId {
            if !isPaused,
               let restSeconds = restSeconds {
                do {
                    try await service.scheduleRestNotifcation(workoutId: workoutId,
                                                              after: restSeconds)
                } catch {
                    // Nothing for now
                    print("Could not schedule notification")
                }
            } else {
                service.deleteRestNotification(workoutId: workoutId)
            }
        }
        
        return .loaded(domain)
    }
    
    func handleMarkExerciseLoading(group: Int, exerciseIndex: Int) -> DoWorkoutDomainResult {
        guard var domain = savedDomain else { return .error }
        
        let numSets = domain.workout.exerciseGroups[group].exercises[exerciseIndex].sets.count
        domain.workout.exerciseGroups[group].exercises[exerciseIndex] = .loadingExercise(numSets: numSets)
        
        return updateDomain(domain: domain)
    }
    
    func handleReplaceExercise(group: Int,
                               exerciseIndex: Int,
                               newExerciseId: String) async -> DoWorkoutDomainResult {
        guard var domain = savedDomain else { return .error }
        
        do {
            let availableExercise = try await service.loadExercise(exerciseId: newExerciseId)
            
            let newGroups = try WorkoutInteractor.replaceExercise(groupIndex: group,
                                                                  groups: domain.workout.exerciseGroups,
                                                                  exerciseIndex: exerciseIndex,
                                                                  availableExercise: availableExercise)
            domain.workout.exerciseGroups = newGroups
            
            return updateDomain(domain: domain)
        } catch {
            return .error
        }
    }
    
    func handleDeleteExercise(group: Int, exerciseIndex: Int) -> DoWorkoutDomainResult {
        guard var domain = savedDomain else { return .error }
        
        var groups = domain.workout.exerciseGroups
        guard group < groups.count  else { return .error }
        
        var targetGroup = groups[group]
        var exercisesInGroup = targetGroup.exercises
        guard exerciseIndex < exercisesInGroup.count else { return .error }
        
        exercisesInGroup.remove(at: exerciseIndex)
        
        // If the group is now empty, we can remove the group altogether
        if exercisesInGroup.isEmpty {
            groups.remove(at: group)
            domain.completedGroups.remove(at: group)
            domain.expandedGroups.remove(at: group)
            domain.fractionCompleted = getFractionCompleted(completedGroups: domain.completedGroups)
            
            // Expand the next incomplete group
            let nextExpandedGroupIndex = getNextIncompleteGroup(completedGroups: domain.completedGroups,
                                                                startingAfter: group - 1)
            
            if let nextExpandedGroupIndex = nextExpandedGroupIndex {
                domain.expandedGroups[nextExpandedGroupIndex] = true
            }
        } else {
            targetGroup.exercises = exercisesInGroup
            groups[group] = targetGroup
        }
        
        domain.workout.exerciseGroups = groups
        
        return updateDomain(domain: domain)
    }
    
    func handleAddModifier(group: Int,
                           exerciseIndex: Int,
                           setIndex: Int,
                           modifier: SetModifier) -> DoWorkoutDomainResult {
        guard var domain = savedDomain else { return .error }
        let updatedGroups = WorkoutInteractor.editModifier(groupIndex: group,
                                                           groups: domain.workout.exerciseGroups,
                                                           exerciseIndex: exerciseIndex,
                                                           setIndex: setIndex,
                                                           modifier: modifier)
        domain.workout.exerciseGroups = updatedGroups
        
        return updateDomain(domain: domain)
    }
    
    func handleRemoveModifier(group: Int, exerciseIndex: Int, setIndex: Int) -> DoWorkoutDomainResult {
        guard var domain = savedDomain else { return .error }
        let updatedGroups = WorkoutInteractor.editModifier(groupIndex: group,
                                                           groups: domain.workout.exerciseGroups,
                                                           exerciseIndex: exerciseIndex,
                                                           setIndex: setIndex,
                                                           modifier: nil)
        domain.workout.exerciseGroups = updatedGroups
        
        return updateDomain(domain: domain)
    }
    
    func handleAddExercises(newExerciseIds: [String]) async -> DoWorkoutDomainResult {
        guard var domain = savedDomain else { return .error }
        
        do {
            var exercises = [AvailableExercise]()
            
            for newExerciseId in newExerciseIds {
                let exercise = try await service.loadExercise(exerciseId: newExerciseId)
                exercises.append(exercise)
            }
            
            let newGroups = WorkoutInteractor.addExercises(groups: domain.workout.exerciseGroups,
                                                           exercises: exercises)
            domain.workout.exerciseGroups = newGroups
            
            let lastGroupCompleted = domain.completedGroups.last ?? false
            domain.completedGroups.append(false)
            domain.expandedGroups.append(lastGroupCompleted)
            domain.fractionCompleted = getFractionCompleted(completedGroups: domain.completedGroups)

            
            return updateDomain(domain: domain)
        } catch {
            return .error
        }
    }
}

// MARK: - Other Private Helpers

private extension DoWorkoutInteractor {
    
    /// Constructs the domain object from loading a workout from the in progress cache.
    /// This happens when the user opens the app after the app crashed mid-workout.
    /// - Parameter restPresets: The user's rest presets
    /// - Returns: The domain object
    func getInProgressWorkoutDomain(restPresets: [Int]) throws -> DoWorkoutDomain {
        let inProgressWorkout = try service.loadInProgressWorkout()
        let workout = inProgressWorkout.workout
        
        workoutId = workout.id
        planId = inProgressWorkout.planId
        
        return DoWorkoutDomain(workout: workout,
                               inCountdown: false,
                               isResting: false,
                               expandedGroups: inProgressWorkout.expandedGroups,
                               completedGroups: inProgressWorkout.completedGroups,
                               fractionCompleted: inProgressWorkout.fractionCompleted,
                               restPresets: restPresets,
                               cachedSecondsElapsed: inProgressWorkout.secondsElapsed,
                               canDeleteExercise: canDeleteExercise(workout: workout))
    }
    
    /// Updates and saves the domain object.
    /// - Parameters:
    ///   - domain: The old domain to update
    ///   - workout: The workout to update
    /// - Returns: The loaded domain state after updating the domain object
    func updateDomain(domain: DoWorkoutDomain) -> DoWorkoutDomainResult {
        var domain = domain
        domain.canDeleteExercise = canDeleteExercise(workout: domain.workout)
        
        savedDomain = domain
        savedDomain?.cachedSecondsElapsed = nil // This should only be set once
        
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
                    let newModifier = createModifierPlaceholder(modifier: set.modifier)
                    let newSet = Set(input: newInput,
                                     modifier: newModifier)
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
    
    /// Creates a new set where the new set's placeholders are the actual inputs of the given set.
    /// - Parameter setInput: The set to create placeholders from
    /// - Returns: A set which only has placeholders
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
    
    /// Creates a new modifier like the one given, except if the given modifier has inputs, the new modifier
    /// will have these inputs be the placeholders of its input.
    /// - Parameter modifier: The modifier to create the placeholders from
    /// - Returns: A modifier whose input (if any) only has placeholders
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
    
    /// Finds the next false value in the list between the given indices.
    /// - Parameters:
    ///   - completedGroups: The list of booleans
    ///   - startIndex: The index to start searching for a false value (inclusive)
    ///   - endIndex: The index to stop searching for a false value (exclusive)
    /// - Returns: The index of the next false value in the list, if it exists (nil otherwise)
    func getNextFalseIndex(completedGroups: [Bool], startIndex: Int, endIndex: Int) -> Int? {
        var currentIndex = startIndex
        
        while currentIndex < endIndex {
            if !completedGroups[currentIndex] {
                return currentIndex
            }
            currentIndex += 1
        }
        return nil
    }
    
    /// Finds the next incomplete group after the given group.
    /// - Parameters:
    ///   - completedGroups: The list of booleans for the completed group statuses
    ///   - group: The group index to start the search from (exclusive)
    /// - Returns: The group index of the next incomplete group if it exists
    func getNextIncompleteGroup(completedGroups: [Bool], startingAfter group: Int) -> Int? {
        // Look for the next group to expand after this group
        var nextExpandedGroupIndex = getNextFalseIndex(completedGroups: completedGroups,
                                                       startIndex: group + 1,
                                                       endIndex: completedGroups.count)
        
        // If not found, wrap around and search from the start
        if nextExpandedGroupIndex == nil {
            nextExpandedGroupIndex = getNextFalseIndex(completedGroups: completedGroups,
                                                       startIndex: 0,
                                                       endIndex: group)
        }
        
        return nextExpandedGroupIndex
    }
    
    func canDeleteExercise(workout: Workout) -> Bool {
        let groups = workout.exerciseGroups
        return groups.count > 1 || (groups.count == 1 && groups[0].exercises.count > 1)
    }
}
