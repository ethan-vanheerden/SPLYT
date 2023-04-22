//
//  BuildWorkoutInteractor.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 1/11/23.
//

import Foundation
import ExerciseCore

// MARK: - Domain Actions

enum BuildWorkoutDomainAction {
    case loadExercises
    case addGroup
    case removeGroup(group: Int)
    case toggleExercise(exerciseId: AnyHashable, group: Int)
    case addSet(group: Int)
    case removeSet(group: Int)
    case updateSet(group: Int, exerciseIndex: Int, setIndex: Int, with: SetInput)
    case toggleFavorite(exerciseId: AnyHashable)
    case switchGroup(to: Int)
    case save
    case toggleDialog(type: BuildWorkoutDialog, isOpen: Bool)
    case addModifier(group: Int, exerciseIndex: Int, setIndex: Int, modifier: SetModifier)
    case removeModifier(group: Int, exerciseIndex: Int, setIndex: Int)
    case updateModifier(group: Int, exerciseIndex: Int, setIndex: Int, with: SetInput)
}

// MARK: - Domain Results

enum BuildWorkoutDomainResult: Equatable {
    case loaded(BuildWorkoutDomain)
    case dialog(type: BuildWorkoutDialog, domain: BuildWorkoutDomain)
    case error
    case exit(BuildWorkoutDomain)
}

// MARK: - Interactor

final class BuildWorkoutInteractor {
    private let service: BuildWorkoutServiceType
    private let nameState: NameWorkoutNavigationState
    private var savedDomain: BuildWorkoutDomain?
    private let creationDate: Date // Used for the workout's id
    
    init(service: BuildWorkoutServiceType = BuildWorkoutService(),
         nameState: NameWorkoutNavigationState,
         creationDate: Date = Date.now) {
        self.service = service
        self.nameState = nameState
        self.creationDate = creationDate
    }
    
    func interact(with action: BuildWorkoutDomainAction) async -> BuildWorkoutDomainResult {
        switch action {
        case .loadExercises:
            return handleLoadExercises()
        case .addGroup:
            return handleAddGroup()
        case .removeGroup(let index):
            return handleRemoveGroup(index: index)
        case let .toggleExercise(exerciseId, group):
            return handleToggleExercise(exerciseId: exerciseId, group: group)
        case .addSet(let group):
            return handleAddSet(group: group)
        case .removeSet(let group):
            return handleRemoveSet(group: group)
        case let .updateSet(group, exerciseIndex, setIndex, newInput):
            return handleUpdateSet(group: group, exerciseIndex: exerciseIndex, setIndex: setIndex, with: newInput)
        case .toggleFavorite(let exerciseId):
            return handleToggleFavorite(exerciseId: exerciseId)
        case .switchGroup(let group):
            return handleSwitchGroup(to: group)
        case .save:
            return handleSave()
        case let .toggleDialog(type, isOpen):
            return handleToggleDialog(type: type, isOpen: isOpen)
        case let .addModifier(group, exerciseIndex, setIndex, modifier):
            return handleAddModifier(group: group, exerciseIndex: exerciseIndex, setIndex: setIndex, modifier: modifier)
        case let .removeModifier(group, exerciseIndex, setIndex):
            return handleRemoveModifier(group: group, exerciseIndex: exerciseIndex, setIndex: setIndex)
        case let .updateModifier(group, exerciseIndex, setIndex, newInput):
            return handleUpdateModifier(group: group, exerciseIndex: exerciseIndex, setIndex: setIndex, with: newInput)
        }
    }
}

// MARK: - Private Handlers

private extension BuildWorkoutInteractor {
    
    func handleLoadExercises() -> BuildWorkoutDomainResult {
        do {
            let exercises = try service.loadAvailableExercises()
            let startingGroup = [ExerciseGroup(exercises: [])]
            let workoutId = getWorkoutId() // ex: Legs-2023-02-15T16:39:57
            let newWorkout = Workout(id: workoutId,
                                     name: nameState.workoutName,
                                     exerciseGroups: startingGroup)
            let domainObject = BuildWorkoutDomain(exercises: exercises,
                                                  builtWorkout: newWorkout,
                                                  currentGroup: 0)
            // Save the domain object for future actions
            return updateSavedDomain(domainObject)
        } catch {
            return .error
        }
    }
    
    func handleAddGroup() -> BuildWorkoutDomainResult {
        guard let domain = savedDomain else { return .error }
        // Create a new empty group
        let newGroup = ExerciseGroup(exercises: [])
        
        var groups = domain.builtWorkout.exerciseGroups
        groups.append(newGroup)
        // Set current group to the added group
        let currentGroup = groups.count - 1 // Zero-indexed
        
        
        return updateDomain(domain: domain,
                            exercises: domain.exercises,
                            groups: groups,
                            currentGroup: currentGroup)
    }
    
    func handleRemoveGroup(index: Int) -> BuildWorkoutDomainResult {
        guard let domain = savedDomain else { return .error }
        // We only remove the group if we have at least 2 groups
        var groups = domain.builtWorkout.exerciseGroups
        let count = groups.count
        if count >= 2 && count > index {
            groups.remove(at: index)
        }
        
        // Update current group index if needed
        let currentGroup = domain.currentGroup
        let newGroup = currentGroup >= index && currentGroup != 0 ? currentGroup - 1 : currentGroup
        
        return updateDomain(domain: domain,
                            exercises: domain.exercises,
                            groups: groups,
                            currentGroup: newGroup)
    }
    
    func handleToggleExercise(exerciseId: AnyHashable, group: Int) -> BuildWorkoutDomainResult {
        guard let domain = savedDomain,
              let id = exerciseId as? String,
              var exercise = domain.exercises[id],
              domain.builtWorkout.exerciseGroups.count > group else { return .error }
        
        if exercise.isSelected {
            return handleRemoveExercise(domain: domain,
                                        availableExercise: &exercise)
        } else {
            return handleAddExercise(domain: domain,
                                     availableExercise: &exercise,
                                     group: group)
        }
    }
    
    func handleAddExercise(domain: BuildWorkoutDomain,
                           availableExercise: inout AvailableExercise,
                           group: Int) -> BuildWorkoutDomainResult {
        
        // Need to calculate how many sets the other exerices in the group have
        var groups = domain.builtWorkout.exerciseGroups
        let numSets = groups[group].exercises.first?.sets.count ?? 1 // If first exercise in group, starts with 1 set
        let exercise = createExercise(from: availableExercise, numSets: numSets)
        
        // Add to group
        var exercisesInGroup = groups[group].exercises
        exercisesInGroup.append(exercise)
        groups[group] = ExerciseGroup(exercises: exercisesInGroup)
        
        // Mark as selected
        availableExercise.isSelected = true
        domain.exercises[availableExercise.id] = availableExercise
        
        return updateDomain(domain: domain,
                            groups: groups,
                            currentGroup: domain.currentGroup)
    }
    
    func handleRemoveExercise(domain: BuildWorkoutDomain,
                              availableExercise: inout AvailableExercise) ->  BuildWorkoutDomainResult {
        var groups = domain.builtWorkout.exerciseGroups
        var fromGroup: ExerciseGroup?
        var fromGroupIndex: Int?
        let id = availableExercise.id
        
        // Find the group which this exercise belongs to
        for (index, group) in groups.enumerated() {
            if group.exercises.map({ $0.id }).contains(id) {
                fromGroup = group
                fromGroupIndex = index
                break
            }
        }
        
        guard let fromGroup = fromGroup,
              let fromGroupIndex = fromGroupIndex else { return .loaded(domain) }
        
        var exercises = fromGroup.exercises
        exercises.removeAll { $0.id == id }
        
        groups[fromGroupIndex] = ExerciseGroup(exercises: exercises)
        
        // Mark as not selected
        availableExercise.isSelected = false
        domain.exercises[id] = availableExercise // Update map
        
        // If the group is now empty and is not the only group
        if groups[fromGroupIndex].exercises.isEmpty {
            _ = updateDomain(domain: domain, groups: groups)
            return handleRemoveGroup(index: fromGroupIndex)
        }
        
        return updateDomain(domain: domain,
                            groups: groups)
    }
    
    func handleAddSet(group: Int) -> BuildWorkoutDomainResult {
        guard let domain = savedDomain else { return .error }
        
        var groups = domain.builtWorkout.exerciseGroups
        let fromGroup = groups[group]
        var exercises = fromGroup.exercises
        
        // We want to add a set to each exercise in the group
        for (index, exercise) in fromGroup.exercises.enumerated() {
            var sets = exercise.sets
            let numSets = sets.count
            let set = Set(input: sets[numSets - 1].input, // Has same input (with values) as previous set
                          modifier: nil)
            sets.append(set)
            let newExercise = Exercise(id: exercise.id,
                                       name: exercise.name,
                                       sets: sets)
            exercises[index] = newExercise
        }
        
        groups[group] = ExerciseGroup(exercises: exercises)
        
        return updateDomain(domain: domain,
                            groups: groups,
                            currentGroup: domain.currentGroup)
    }
    
    func handleRemoveSet(group: Int) -> BuildWorkoutDomainResult {
        guard let domain = savedDomain else { return .error }
        
        var groups = domain.builtWorkout.exerciseGroups
        let fromGroup = groups[group]
        
        var exercises = fromGroup.exercises
        
        // We want to remove a set from each exercise in the group
        guard exercises.count >= 1,
              exercises.first?.sets.count ?? 0 > 1 else { return .loaded(domain) } // Do nothing
        
        for (index, exercise) in fromGroup.exercises.enumerated() {
            var sets = exercise.sets
            sets.removeLast()
            let newExercise = Exercise(id: exercise.id,
                                       name: exercise.name,
                                       sets: sets)
            exercises[index] = newExercise
        }
        
        groups[group] = ExerciseGroup(exercises: exercises)
        
        return updateDomain(domain: domain,
                            exercises: domain.exercises,
                            groups: groups,
                            currentGroup: domain.currentGroup)
    }
    
    func handleUpdateSet(group: Int,
                         exerciseIndex: Int,
                         setIndex: Int,
                         with newInput: SetInput) -> BuildWorkoutDomainResult {
        return updateSet(group: group,
                         exerciseIndex: exerciseIndex,
                         setIndex: setIndex,
                         newSetInput: newInput,
                         newModifierInput: nil)
    }
    
    func handleToggleFavorite(exerciseId: AnyHashable) -> BuildWorkoutDomainResult {
        guard let domain = savedDomain,
              let id = exerciseId as? String,
              var exercise = domain.exercises[id] else { return .error }
        
        exercise.isFavorite = !exercise.isFavorite
        domain.exercises[id] = exercise
        
        // Save the changes
        do {
            try service.saveAvailableExercises(Array(domain.exercises.values))
        } catch {
            return .error
        }
        
        return updateDomain(domain: domain)
    }
    
    func handleSwitchGroup(to group: Int) -> BuildWorkoutDomainResult {
        guard let domain = savedDomain,
              group >= 0,
              group < domain.builtWorkout.exerciseGroups.count else { return .error }
        
        return updateDomain(domain: domain,
                            currentGroup: group)
    }
    
    func handleSave() -> BuildWorkoutDomainResult {
        guard let domain = savedDomain else { return .error }
        do {
            try service.saveWorkout(domain.builtWorkout)
            return .exit(domain)
        } catch {
            return .dialog(type: .save, domain: domain) // Show the error dialog
        }
    }
    
    func handleToggleDialog(type: BuildWorkoutDialog, isOpen: Bool) -> BuildWorkoutDomainResult {
        guard let domain = savedDomain else { return .error }
        
        // Show dialog if needed
        return isOpen ? .dialog(type: type, domain: domain) : .loaded(domain)
    }
    
    func handleAddModifier(group: Int,
                           exerciseIndex: Int,
                           setIndex: Int,
                           modifier: SetModifier) -> BuildWorkoutDomainResult {
        return editModifier(group: group,
                            exerciseIndex: exerciseIndex,
                            setIndex: setIndex,
                            modifier: modifier)
    }
    
    // Assumes there is a modifier to remove
    func handleRemoveModifier(group: Int, exerciseIndex: Int, setIndex: Int) -> BuildWorkoutDomainResult {
        return editModifier(group: group,
                            exerciseIndex: exerciseIndex,
                            setIndex: setIndex,
                            modifier: nil)
    }
    
    func handleUpdateModifier(group: Int,
                              exerciseIndex: Int,
                              setIndex: Int,
                              with newInput: SetInput) -> BuildWorkoutDomainResult {
        return updateSet(group: group,
                         exerciseIndex: exerciseIndex,
                         setIndex: setIndex,
                         newSetInput: nil,
                         newModifierInput: newInput)
    }
}

// MARK: - Other Private Helpers

private extension BuildWorkoutInteractor {
    
    /// Returns a string representation of the workout creation name and date in the form of: name-2023-02-15T16:39:57Z.
    /// This is used to make workout identifiers unique.
    /// - Returns: The unique workout id of the current workout being made
    func getWorkoutId() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        return nameState.workoutName + "-" + formatter.string(from: creationDate)
    }
    
    func updateSavedDomain(_ newDomain: BuildWorkoutDomain) -> BuildWorkoutDomainResult {
        savedDomain = newDomain
        return .loaded(newDomain)
    }
    
    /// Updates and saves the domain object. Note: most of the arguments are nil so that we only have to update what we want.
    /// - Parameters:
    ///   - domain: The saved domain object (not nil)
    ///   - exercises: The available exercises to update
    ///   - groups: The exercise groups to update
    /// - Returns: The loaded domain state after updating the saved domain object
    func updateDomain(domain: BuildWorkoutDomain,
                      exercises: [String: AvailableExercise]? = nil,
                      groups: [ExerciseGroup]? = nil,
                      currentGroup: Int? = nil) -> BuildWorkoutDomainResult {
        let groups = groups ?? domain.builtWorkout.exerciseGroups
        let updatedWorkout = Workout(id: domain.builtWorkout.id,
                                     name: domain.builtWorkout.name,
                                     exerciseGroups: groups,
                                     lastCompleted: domain.builtWorkout.lastCompleted)
        domain.exercises = exercises ?? domain.exercises
        domain.builtWorkout = updatedWorkout
        domain.currentGroup = currentGroup ?? domain.currentGroup
        
        return updateSavedDomain(domain)
    }
    
    /// Creates a new exercise with the given number of sets.
    /// - Parameters:
    ///   - available: The `AvailableExercise` that this exercise is based on
    ///   - numSets: The number of sets this exercise will have
    /// - Returns: The exercise
    func createExercise(from available: AvailableExercise, numSets: Int) -> Exercise {
        let id = available.id
        var sets: [Set] = []
        
        for _ in 1...numSets {
            let newSet = Set(input: available.defaultInputType,
                             modifier: nil)
            sets.append(newSet)
        }
        
        return Exercise(id: id,
                        name: available.name,
                        sets: sets)
    }
    
    /// Finds the `AvailableExercise` version from the id of an `Exercise`
    /// - Parameters:
    ///   - id: The id of the exercise to find
    ///   - exercises: The available exercises to search in
    /// - Returns: The `AvailableExercise` if it exists, nil otherwise
    func findExercise(id: String, exercises: [AvailableExercise]) -> AvailableExercise? {
        return exercises.first { $0.id == id }
    }
    
    /// Either adds or removes a modifier into a set. Assumes all the indices are valid.
    /// - Parameters:
    ///   - group: The group index that the set belongs to
    ///   - exerciseIndex: The exercise index in the group which has the target set
    ///   - setIndex: The set index in the exercise that we want to add the modifier to
    ///   - modifier: The modifier to add or remove. If nil, we remove, else we add
    /// - Returns: The domain result with the updated set
    func editModifier(group: Int,
                      exerciseIndex: Int,
                      setIndex: Int,
                      modifier: SetModifier?) -> BuildWorkoutDomainResult {
        guard let domain = savedDomain else { return .error }
        
        var groups = domain.builtWorkout.exerciseGroups
        let exercises = groups[group].exercises
        let targetExercise = exercises[exerciseIndex]
        
        let oldSet = targetExercise.sets[setIndex]
        let newSet = Set(input: oldSet.input,
                         modifier: modifier)

        return replaceSet(domain: domain,
                          groupIndex: group,
                          targetExercise: targetExercise,
                          oldExercises: exercises,
                          newSet: newSet,
                          newSetIndex: setIndex,
                          exerciseIndex: exerciseIndex,
                          groups: &groups)
    }
    
    /// Updates a set to have the new input and modifier (if present). Assumes all the indices are valid.
    /// - Parameters:
    ///   - group: The group index the set belongs to
    ///   - exerciseIndex: The exercise index in the group the set belongs to
    ///   - setIndex: The set index in the exercise the set belongs to
    ///   - newSetInput: The new input of the set
    ///   - newModifierInput: The new input of the set's modifier
    /// - Returns: The domain result with the updated set
    func updateSet(group: Int,
                   exerciseIndex: Int,
                   setIndex: Int,
                   newSetInput: SetInput?,
                   newModifierInput: SetInput?) -> BuildWorkoutDomainResult {
        guard let domain = savedDomain else { return .error }
        
        var groups = domain.builtWorkout.exerciseGroups
        let exercises = groups[group].exercises
        let targetExercise = exercises[exerciseIndex]
        
        let oldSet = targetExercise.sets[setIndex]
        let newSet = Set(input: oldSet.input.updateSetInput(with: newSetInput),
                         modifier: oldSet.modifier?.updateModifierInput(with: newModifierInput))
        
        return replaceSet(domain: domain,
                          groupIndex: group,
                          targetExercise: targetExercise,
                          oldExercises: exercises,
                          newSet: newSet,
                          newSetIndex: setIndex,
                          exerciseIndex: exerciseIndex,
                          groups: &groups)
    }
    
    /// Replaces a given set in the workout.
    /// - Parameters:
    ///   - domain: The domain object
    ///   - groupIndex: The group index of the set we want to replace
    ///   - targetExercise: The exercise that the set belongs to
    ///   - oldExercises: The list of exercises which includes the old set
    ///   - newSet: The new set that we want to use
    ///   - newSetIndex: The set index of the one to be replaced
    ///   - exerciseIndex: The exercise index in the group which will have the new set
    ///   - groups: The exercise groups which includes the old set
    /// - Returns: The domain result with the replaced set
    func replaceSet(domain: BuildWorkoutDomain,
                    groupIndex: Int,
                    targetExercise: Exercise,
                    oldExercises: [Exercise],
                    newSet: Set,
                    newSetIndex: Int,
                    exerciseIndex: Int,
                    groups: inout [ExerciseGroup]) -> BuildWorkoutDomainResult {
        var newSets = targetExercise.sets
        newSets[newSetIndex] = newSet
        
        // Add the new sets to the exercise
        var newExercises = oldExercises
        let newExercise = Exercise(id: targetExercise.id,
                                   name: targetExercise.name,
                                   sets: newSets)
        newExercises[exerciseIndex] = newExercise
        
        // Replace the exercise in its group
        groups[groupIndex] = ExerciseGroup(exercises: newExercises)
        
        return updateDomain(domain: domain, groups: groups)
    }
}
