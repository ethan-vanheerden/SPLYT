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
    case toggleExercise(exerciseId: String)
    case addSet(group: Int)
    case removeSet(group: Int)
    case updateSet(group: Int, exerciseIndex: Int, setIndex: Int, with: SetInput)
    case toggleFavorite(exerciseId: String)
    case switchGroup(to: Int)
    case save
    case toggleDialog(type: BuildWorkoutDialog, isOpen: Bool)
    case addModifier(group: Int, exerciseIndex: Int, setIndex: Int, modifier: SetModifier)
    case removeModifier(group: Int, exerciseIndex: Int, setIndex: Int)
    case updateModifier(group: Int, exerciseIndex: Int, setIndex: Int, with: SetInput)
    case filter(by: BuildWorkoutFilter)
    case removeAllFilters
    case createSuperset
    case cancelSuperset
    case saveSuperset
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
    private let creationDate: Date // Used for the workout's id
    private let saveAction: ((Workout) -> Void)? // Custom override save action
    private var savedDomain: BuildWorkoutDomain?
    private var allExercises: [String: AvailableExercise]? // Used when we cancel a search
    private var selectedExerciseIds: [String] = []
    
    init(service: BuildWorkoutServiceType = BuildWorkoutService(),
         nameState: NameWorkoutNavigationState,
         creationDate: Date = Date.now,
         saveAction: ((Workout) -> Void)? = nil) {
        self.service = service
        self.nameState = nameState
        self.creationDate = creationDate
        self.saveAction = saveAction
    }
    
    func interact(with action: BuildWorkoutDomainAction) async -> BuildWorkoutDomainResult {
        switch action {
        case .loadExercises:
            return await handleLoadExercises()
        case .addGroup:
            return handleAddGroup()
        case let .toggleExercise(exerciseId):
            return handleToggleExercise(exerciseId: exerciseId)
        case .addSet(let group):
            return handleAddSet(group: group)
        case .removeSet(let group):
            return handleRemoveSet(group: group)
        case let .updateSet(group, exerciseIndex, setIndex, newInput):
            return handleUpdateSet(group: group, exerciseIndex: exerciseIndex, setIndex: setIndex, with: newInput)
        case .toggleFavorite(let exerciseId):
            return await handleToggleFavorite(exerciseId: exerciseId)
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
        case .filter(let filter):
            return handleFilter(by: filter)
        case .removeAllFilters:
            return handleRemoveAllFilters()
        case .createSuperset:
            return .error
        case .cancelSuperset:
            return .error
        case .saveSuperset:
            return .error
        }
    }
}

// MARK: - Private Handlers

private extension BuildWorkoutInteractor {
    
    func handleLoadExercises() async -> BuildWorkoutDomainResult {
        do {
            let exercises = try await service.loadAvailableExercises()
            allExercises = exercises
            let startingGroup = [ExerciseGroup(exercises: [])]
            let workoutId = WorkoutInteractor.getId(name: nameState.name,
                                                    creationDate: creationDate)
            
            let newWorkout = Workout(id: workoutId,
                                     name: nameState.name,
                                     exerciseGroups: startingGroup,
                                     createdAt: creationDate)
            
            let domain = BuildWorkoutDomain(exercises: exercises,
                                            builtWorkout: newWorkout,
                                            currentGroup: 0,
                                            filterDomain: createEmptyFilters(),
                                            canSave: false,
                                            isCreatingSuperset: false)
            // Save the domain object for future actions
            return updateDomain(domain: domain)
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
        
        domain.builtWorkout.exerciseGroups = groups
        domain.currentGroup = currentGroup
        
        return updateDomain(domain: domain)
    }
    
    func handleToggleExercise(exerciseId: String) -> BuildWorkoutDomainResult {
        guard let domain = savedDomain,
              var exercise = domain.exercises[exerciseId],
              domain.builtWorkout.exerciseGroups.count > domain.currentGroup else { return .error }
        
        let currentGroup = domain.currentGroup
        
        if exercise.selectedGroups.contains(currentGroup) {
            return handleRemoveExercise(domain: domain,
                                        availableExercise: &exercise)
        } else {
            return handleAddExercise(domain: domain,
                                     availableExercise: &exercise)
        }
    }
    
    func handleAddExercise(domain: BuildWorkoutDomain,
                           availableExercise: inout AvailableExercise) -> BuildWorkoutDomainResult {
        // Need to calculate how many sets the other exerices in the group have
        let group = domain.currentGroup
        var groups = domain.builtWorkout.exerciseGroups
        let numSets = groups[group].exercises.first?.sets.count ?? 1 // If first exercise in group, starts with 1 set
        let exercise = createExercise(from: availableExercise, numSets: numSets)
        
        // Add to group
        var exercisesInGroup = groups[group].exercises
        exercisesInGroup.append(exercise)
        groups[group].exercises = exercisesInGroup
        
        // Mark as selected for that group
        let exerciseId = availableExercise.id
        availableExercise.selectedGroups.append(group)
        availableExercise.selectedGroups.sort()
        
        allExercises?[exerciseId]?.selectedGroups = availableExercise.selectedGroups
        selectedExerciseIds.append(exerciseId)
        
        domain.exercises[exerciseId] = availableExercise
        domain.builtWorkout.exerciseGroups = groups
        
        return updateDomain(domain: domain)
    }
    
    func handleRemoveExercise(domain: BuildWorkoutDomain,
                              availableExercise: inout AvailableExercise) ->  BuildWorkoutDomainResult {
        var groups = domain.builtWorkout.exerciseGroups
        let currentGroup = domain.currentGroup
        let fromGroup = groups[currentGroup]
        let exerciseId = availableExercise.id
        
        var exercises = fromGroup.exercises
        exercises.removeAll { $0.id == exerciseId }
        
        groups[currentGroup].exercises = exercises
        
        // Mark as not selected
        availableExercise.selectedGroups.removeAll { $0 == currentGroup }
        domain.exercises[exerciseId] = availableExercise
        
        allExercises?[exerciseId]?.selectedGroups = availableExercise.selectedGroups
        
        if let indexToRemove = selectedExerciseIds.firstIndex(of: exerciseId) {
            selectedExerciseIds.remove(at: indexToRemove)
        }
        
        domain.builtWorkout.exerciseGroups = groups
        
        return updateDomain(domain: domain)
    }
    
    func handleAddSet(group: Int) -> BuildWorkoutDomainResult {
        guard let domain = savedDomain else { return .error }
        let updatedGroups = WorkoutInteractor.addSet(group: group,
                                                     groups: domain.builtWorkout.exerciseGroups)
        domain.builtWorkout.exerciseGroups = updatedGroups
        
        return updateDomain(domain: domain)
    }
    
    func handleRemoveSet(group: Int) -> BuildWorkoutDomainResult {
        guard let domain = savedDomain else { return .error }
        let updatedGroups = WorkoutInteractor.removeSet(group: group,
                                                        groups: domain.builtWorkout.exerciseGroups)
        domain.builtWorkout.exerciseGroups = updatedGroups
        
        return updateDomain(domain: domain)
    }
    
    func handleUpdateSet(group: Int,
                         exerciseIndex: Int,
                         setIndex: Int,
                         with newInput: SetInput) -> BuildWorkoutDomainResult {
        guard let domain = savedDomain else { return .error }
        let updatedGroups = WorkoutInteractor.updateSet(groupIndex: group,
                                                        groups: domain.builtWorkout.exerciseGroups,
                                                        exerciseIndex: exerciseIndex,
                                                        setIndex: setIndex,
                                                        newSetInput: newInput,
                                                        newModifierInput: nil)
        domain.builtWorkout.exerciseGroups = updatedGroups
        
        return updateDomain(domain: domain)
    }
    
    func handleToggleFavorite(exerciseId: String) async -> BuildWorkoutDomainResult {
        guard let domain = savedDomain,
              var exercises = allExercises,
              var exercise = exercises[exerciseId] else { return .error }
        
        let isFavorite = !exercise.isFavorite
        exercise.isFavorite = isFavorite
        domain.exercises[exerciseId] = exercise
        exercises[exerciseId]?.isFavorite = isFavorite
        
        // Save the changes
        do {
            allExercises = exercises
            try await service.toggleFavorite(exerciseId: exerciseId, isFavorite: isFavorite)
        } catch {
            return .error
        }
        
        return updateDomain(domain: domain)
    }
    
    func handleSwitchGroup(to group: Int) -> BuildWorkoutDomainResult {
        guard let domain = savedDomain,
              group >= 0,
              group < domain.builtWorkout.exerciseGroups.count else { return .error }
        
        let oldGroup = domain.currentGroup
        domain.currentGroup = group
        return removeGroupIfNeeded(index: oldGroup, domain: domain)
    }
    
    func handleSave() -> BuildWorkoutDomainResult {
        guard let domain = savedDomain else { return .error }
        do {
            if let saveAction = saveAction {
                saveAction(domain.builtWorkout)
            } else {
                try service.saveWorkout(domain.builtWorkout)
            }
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
        guard let domain = savedDomain else { return .error }
        let updatedGroups = WorkoutInteractor.editModifier(groupIndex: group,
                                                           groups: domain.builtWorkout.exerciseGroups,
                                                           exerciseIndex: exerciseIndex,
                                                           setIndex: setIndex,
                                                           modifier: modifier)
        domain.builtWorkout.exerciseGroups = updatedGroups
        
        return updateDomain(domain: domain)
    }
    
    // Assumes there is a modifier to remove
    func handleRemoveModifier(group: Int, exerciseIndex: Int, setIndex: Int) -> BuildWorkoutDomainResult {
        guard let domain = savedDomain else { return .error }
        let updatedGroups = WorkoutInteractor.editModifier(groupIndex: group,
                                                           groups: domain.builtWorkout.exerciseGroups,
                                                           exerciseIndex: exerciseIndex,
                                                           setIndex: setIndex,
                                                           modifier: nil)
        domain.builtWorkout.exerciseGroups = updatedGroups
        
        return updateDomain(domain: domain)
    }
    
    func handleUpdateModifier(group: Int,
                              exerciseIndex: Int,
                              setIndex: Int,
                              with newInput: SetInput) -> BuildWorkoutDomainResult {
        guard let domain = savedDomain else { return .error }
        let updatedGroups = WorkoutInteractor.updateSet(groupIndex: group,
                                                        groups: domain.builtWorkout.exerciseGroups,
                                                        exerciseIndex: exerciseIndex,
                                                        setIndex: setIndex,
                                                        newSetInput: nil,
                                                        newModifierInput: newInput)
        domain.builtWorkout.exerciseGroups = updatedGroups
        
        return updateDomain(domain: domain)
    }
    
    func handleFilter(by filter: BuildWorkoutFilter) -> BuildWorkoutDomainResult {
        guard let domain = savedDomain else { return .error }
        
        switch filter {
        case .search(let searchText):
            return filterBySearch(domain: domain, searchText: searchText)
        case .favorite(let isFavorite):
            return filterByFavorite(domain: domain, isFavorite: isFavorite)
        case let .muscleWorked(muscle, isSelected):
            return filterByMuscleWorked(domain: domain, muscleWorked: muscle, isSelected: isSelected)
        }
    }
    
    func handleRemoveAllFilters() -> BuildWorkoutDomainResult {
        guard let domain = savedDomain else { return .error }
        
        let searchText = domain.filterDomain.searchText // We want to keep the search text
        domain.filterDomain = createEmptyFilters()
        
        return filterBySearch(domain: domain, searchText: searchText)
    }
}

// MARK: - Other Private Helpers

private extension BuildWorkoutInteractor {
    
    /// Updates and saves the domain object. Note: most of the arguments are nil so that we only have to update what we want.
    /// - Parameters:
    ///   - domain: The saved domain object (not nil)
    ///   - exercises: The available exercises to update
    ///   - groups: The exercise groups to update
    /// - Returns: The loaded domain state after updating the saved domain object
    func updateDomain(domain: BuildWorkoutDomain) -> BuildWorkoutDomainResult {
        domain.canSave = !domain.builtWorkout.exerciseGroups[0].exercises.isEmpty
        savedDomain = domain
        return .loaded(domain)
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
    
    func createEmptyFilters() -> BuildWorkoutFilterDomain {
        var musclesWorked = [MusclesWorked: Bool]()
        for muscle in MusclesWorked.allCases {
            musclesWorked[muscle] = false
        }
        
        return .init(searchText: "",
                     isFavorite: false,
                     musclesWorked: musclesWorked)
    }
    
    func filterBySearch(domain: BuildWorkoutDomain, searchText: String) -> BuildWorkoutDomainResult {
        domain.filterDomain.searchText = searchText
        return filterExercises(domain: domain)
    }
    
    func filterByFavorite(domain: BuildWorkoutDomain, isFavorite: Bool) -> BuildWorkoutDomainResult {
        domain.filterDomain.isFavorite = isFavorite
        return filterExercises(domain: domain)
    }
    
    func filterByMuscleWorked(domain: BuildWorkoutDomain,
                              muscleWorked: MusclesWorked,
                              isSelected: Bool) -> BuildWorkoutDomainResult {
        domain.filterDomain.musclesWorked[muscleWorked] = isSelected
        return filterExercises(domain: domain)
    }
    
    func filterExercises(domain: BuildWorkoutDomain) -> BuildWorkoutDomainResult {
        guard let allExercises = allExercises else { return .error }
        
        let filteredExercises = allExercises.filter {
            let exercise = $0.value
            var shouldInclude = true
            
            // Filter by search only if search is not ""
            // Filter by isFavorite only if isFavorite is true
            // Filter by musclesWorked only if musclesWorked contains a true value
            let searchText = domain.filterDomain.searchText
            let isFavorite = domain.filterDomain.isFavorite
            let musclesWorked = domain.filterDomain.musclesWorked
            
            if !searchText.isEmpty {
                shouldInclude = shouldInclude && exercise.name.lowercased().contains(searchText.lowercased())
            }
            
            if isFavorite {
                shouldInclude = shouldInclude && exercise.isFavorite
            }
            
            if musclesWorked.values.contains(true) {
                var hasMuscle = false
                exercise.musclesWorked.forEach { muscle in
                    if musclesWorked[muscle] ?? false {
                        hasMuscle = true
                    }
                }
                shouldInclude = shouldInclude && hasMuscle
            }
            
            return shouldInclude
        }
        
        domain.exercises = filteredExercises
        return updateDomain(domain: domain)
    }
    
    /// Removes the exercise group at the specified index if we can. The group is only removed if it is empty,
    /// it is not the current group, and it is not the only group in the workout.
    /// - Parameters
    ///     index: The index of the group to possibly remove.
    ///     domain: The domain to remove the group from
    /// - Returns: The updated domain result
    func removeGroupIfNeeded(index: Int, domain: BuildWorkoutDomain) -> BuildWorkoutDomainResult {
        var groups = domain.builtWorkout.exerciseGroups
        let groupCount = groups.count
        let isEmpty = groups[index].exercises.isEmpty
        let currentGroup = domain.currentGroup
        
        guard isEmpty, currentGroup != index, groupCount > 1 else {
            return updateDomain(domain: domain)
        }
        
        groups.remove(at: index)
        domain.currentGroup = currentGroup >= index && currentGroup != 0 ? currentGroup - 1 : currentGroup
        domain.builtWorkout.exerciseGroups = groups
        
        // Update the selected group numbers for each of the selected exercises
        var domainExercises = domain.exercises
        let selectedExercises = Swift.Set(selectedExerciseIds)
        
        for selectedExercise in selectedExercises {
            guard var exercise = domainExercises[selectedExercise] else { continue }

            exercise.selectedGroups = exercise.selectedGroups.map { groupIndex in
                return groupIndex > index ? groupIndex - 1 : groupIndex
            }
            domainExercises[selectedExercise] = exercise
            allExercises?[selectedExercise] = exercise
        }
        
        domain.exercises = domainExercises
        
        return updateDomain(domain: domain)
    }
}
