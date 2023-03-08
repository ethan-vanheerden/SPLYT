//
//  BuildWorkoutInteractor.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 1/11/23.
//

import Foundation

// MARK: - Domain Actions

enum BuildWorkoutDomainAction {
    case loadExercises
    case addGroup
    case removeGroup(group: Int)
    case toggleExercise(id: AnyHashable, group: Int)
    case addSet(group: Int)
    case removeSet(group: Int)
    case updateSet(id: AnyHashable, group: Int, with: SetInputType)
    case toggleFavorite(id: AnyHashable)
    case switchGroup(to: Int)
    case save
    case toggleDialog(type: BuildWorkoutDialog, isOpen: Bool)
}

// MARK: - Domain Results

enum BuildWorkoutDomainResult: Equatable {
    case loaded(BuildWorkoutDomainObject)
    case dialog(type: BuildWorkoutDialog, domain: BuildWorkoutDomainObject)
    case error
    case exit(BuildWorkoutDomainObject)
}

// MARK: - Interactor

final class BuildWorkoutInteractor {
    private let service: BuildWorkoutServiceType
    private let nameState: NameWorkoutNavigationState
    private var savedDomain: BuildWorkoutDomainObject?
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
        case let .toggleExercise(id, group):
            return handleToggleExercise(id: id, group: group)
        case .addSet(let group):
            return handleAddSet(group: group)
        case .removeSet(let group):
            return handleRemoveSet(group: group)
        case let .updateSet(id, group, newInput):
            return handleUpdateSet(id: id, group: group, with: newInput)
        case .toggleFavorite(let id):
            return handleToggleFavorite(id: id)
        case .switchGroup(let group):
            return handleSwitchGroup(to: group)
        case .save:
            return handleSave()
        case let .toggleDialog(type, isOpen):
            return handleToggleDialog(type: type, isOpen: isOpen)
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
                                     exerciseGroups: startingGroup,
                                     lastCompleted: nil)
            let domainObject = BuildWorkoutDomainObject(exercises: exercises,
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
        let currentGroup = max(domain.currentGroup - 1, 0) // Current group will be one less
        
        return updateDomain(domain: domain,
                            exercises: domain.exercises,
                            groups: groups,
                            currentGroup: currentGroup)
    }
    
    func handleToggleExercise(id: AnyHashable, group: Int) -> BuildWorkoutDomainResult {
        guard let domain = savedDomain,
              let id = id as? String,
              let exerciseIndex = domain.exercises.firstIndex(where: { $0.id == id }),
              domain.builtWorkout.exerciseGroups.count > group else { return .error }
        
        if domain.exercises[exerciseIndex].isSelected {
            return handleRemoveExercise(domain: domain, id: id, index: exerciseIndex, group: group)
        } else {
            return handleAddExercise(domain: domain, index: exerciseIndex, group: group)
        }
    }
    
    func handleAddExercise(domain: BuildWorkoutDomainObject,
                           index: Int,
                           group: Int) -> BuildWorkoutDomainResult {
        let availableExercise = domain.exercises[index]
        
        // Need to calculate how many sets the other exerices in the group have
        var groups = domain.builtWorkout.exerciseGroups
        let numSets = groups[group].exercises.first?.sets.count ?? 1 // If first exercise in group, starts with 1 set
        let exercise = createExercise(from: availableExercise, numSets: numSets)
        
        // Add to group
        var exercisesInGroup = groups[group].exercises
        exercisesInGroup.append(exercise)
        groups[group] = ExerciseGroup(exercises: exercisesInGroup)
        
        // Mark as selected
        var newAvailable = domain.exercises
        newAvailable[index].isSelected = true
        
        return updateDomain(domain: domain,
                            exercises: newAvailable,
                            groups: groups,
                            currentGroup: domain.currentGroup)
    }
    
    func handleRemoveExercise(domain: BuildWorkoutDomainObject,
                              id: String,
                              index: Int,
                              group: Int) ->  BuildWorkoutDomainResult {
        var groups = domain.builtWorkout.exerciseGroups
        let fromGroup = groups[group]
        
        guard fromGroup.exercises.count > 0 else { return .error }
        
        var exercises = fromGroup.exercises
        exercises.removeAll { $0.id == id }
        
        groups[group] = ExerciseGroup(exercises: exercises)
        
        // Mark as not selected
        var newAvailable = domain.exercises
        newAvailable[index].isSelected = false
        
        return updateDomain(domain: domain,
                            exercises: newAvailable,
                            groups: groups,
                            currentGroup: domain.currentGroup)
    }
    
    func handleAddSet(group: Int) -> BuildWorkoutDomainResult {
        guard let domain = savedDomain else { return .error }
        
        var groups = domain.builtWorkout.exerciseGroups
        let fromGroup = groups[group]
        var exercises = fromGroup.exercises
        
        // We want to add a set to each exercise in the group
        exercises.forEach { exercise in
            var sets = exercise.sets
            let set = Set(id: "\(exercise.id)-set-\(sets.count + 1)",
                          inputType: sets.first?.inputType ?? .repsWeight(reps: nil, weight: nil),
                          modifier: nil)
            sets.append(set)
        }
        
        for (index, exercise) in fromGroup.exercises.enumerated() {
            var sets = exercise.sets
            let set = Set(id: "\(exercise.id)-set-\(sets.count + 1)",
                          inputType: sets.first?.inputType ?? .repsWeight(reps: nil, weight: nil),
                          modifier: nil)
            sets.append(set)
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
    
    func handleRemoveSet(group: Int) -> BuildWorkoutDomainResult {
        guard let domain = savedDomain else { return .error }
        
        var groups = domain.builtWorkout.exerciseGroups
        let fromGroup = groups[group]
        
        var exercises = fromGroup.exercises
        
        // We want to remove a set from each exercise in the group
        guard exercises.count >= 1,
              exercises.first!.sets.count > 1 else { return .loaded(domain) } // Do nothing
        
        exercises.forEach { exercise in
            var sets = exercise.sets
            sets.removeLast()
        }
        
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
    
    func handleUpdateSet(id: AnyHashable, group: Int, with newInput: SetInputType) -> BuildWorkoutDomainResult {
        guard let domain = savedDomain,
              let id = id as? String else { return .error }
        
        var groups = domain.builtWorkout.exerciseGroups
        let exercises = groups[group].exercises
        
    outerLoop: for (exerciseIndex, exercise) in exercises.enumerated() {
        for (setIndex, set) in exercise.sets.enumerated() {
            if set.id == id {
                let newSet = Set(id: set.id,
                                 inputType: newInput, // Update input
                                 modifier: nil) // Reset modifier as well
                var newSets = exercise.sets
                newSets[setIndex] = newSet
                
                var newExercises = exercises
                let newExercise = Exercise(id: exercise.id,
                                           name: exercise.name,
                                           sets: newSets)
                newExercises[exerciseIndex] = newExercise
                groups[group] = ExerciseGroup(exercises: newExercises)
                
                break outerLoop
            }
        }
    }
        
        return updateDomain(domain: domain,
                            exercises: domain.exercises,
                            groups: groups,
                            currentGroup: domain.currentGroup)
    }
    
    func handleToggleFavorite(id: AnyHashable) -> BuildWorkoutDomainResult {
        guard let domain = savedDomain,
              let id = id as? String else { return .error }
        
        var exercises = domain.exercises
        
        for (index, exercise) in domain.exercises.enumerated() {
            if exercise.id == id {
                let newExercise = AvailableExercise(id: exercise.id,
                                                    name: exercise.name,
                                                    musclesWorked: exercise.musclesWorked,
                                                    isFavorite: !exercise.isFavorite,
                                                    defaultInputType: exercise.defaultInputType,
                                                    isSelected: exercise.isSelected)
                exercises[index] = newExercise
                break
            }
        }
        
        let newDomain = BuildWorkoutDomainObject(exercises: exercises,
                                                 builtWorkout: domain.builtWorkout,
                                                 currentGroup: domain.currentGroup)
        
        
        // Save the changes
        do {
            try service.saveAvailableExercises(exercises)
        } catch {
            return .error
        }
        
        return updateSavedDomain(newDomain)
    }
    
    func handleSwitchGroup(to group: Int) -> BuildWorkoutDomainResult {
        guard let domain = savedDomain,
              group >= 0,
              group < domain.builtWorkout.exerciseGroups.count else { return .error }
        
        let newDomain = BuildWorkoutDomainObject(exercises: domain.exercises,
                                                 builtWorkout: domain.builtWorkout,
                                                 currentGroup: group)
        
        return updateSavedDomain(newDomain)
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
}

// MARK: - Other Private Helpers

private extension BuildWorkoutInteractor {
    
    /// Returns a string representation of the workout creation date in the form of: 2023-02-15T16:39:57Z. This is used to make workout identifiers unique.
    /// - Returns: The creation date of the current workout as a string with that format
    func getWorkoutId() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        return nameState.workoutName + "-" + formatter.string(from: creationDate)
    }
    
    func updateSavedDomain(_ newDomain: BuildWorkoutDomainObject) -> BuildWorkoutDomainResult {
        savedDomain = newDomain
        return .loaded(newDomain)
    }
    
    /// Updates and saves the domain object.
    /// - Parameters:
    ///   - domain: The saved domain object (not nil)
    ///   - exercises: The available exercises to update
    ///   - groups: The exercise groups to update
    /// - Returns: The loaded domain state after updating the saved domain object to have the new exercise groups and available exercises
    func updateDomain(domain: BuildWorkoutDomainObject,
                      exercises: [AvailableExercise],
                      groups: [ExerciseGroup],
                      currentGroup: Int) -> BuildWorkoutDomainResult {
        let updatedWorkout = Workout(id: domain.builtWorkout.id,
                                     name: domain.builtWorkout.name,
                                     exerciseGroups: groups,
                                     lastCompleted: domain.builtWorkout.lastCompleted)
        let updatedDomain = BuildWorkoutDomainObject(exercises: exercises,
                                                     builtWorkout: updatedWorkout,
                                                     currentGroup: currentGroup)
        return updateSavedDomain(updatedDomain)
    }
    
    /// Creates a new exercise with the given number of sets.
    /// - Parameters:
    ///   - available: The `AvailableExercise` that this exercise is based on
    ///   - numSets: The number of sets this exercise will have
    /// - Returns: The exercise
    func createExercise(from available: AvailableExercise, numSets: Int) -> Exercise {
        let id = available.id
        var sets: [Set] = []
        
        for i in 1...numSets {
            let newSet = Set(id: "\(id)-set-\(i)",
                             inputType: available.defaultInputType,
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
}
