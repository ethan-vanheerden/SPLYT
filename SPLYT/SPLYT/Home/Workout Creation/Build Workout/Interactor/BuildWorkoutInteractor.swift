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
    case toggleExercise(exerciseId: String)
    case addSet(group: Int)
    case removeSet(group: Int)
    case updateSet(group: Int, exerciseIndex: Int, setIndex: Int, with: SetInput)
    case toggleFavorite(exerciseId: String)
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
    case nextTapped
    case backTapped(userInitiated: Bool)
    case deleteGroup(groupIndex: Int)
    case rearrangeGroups(newOrder: [Int])
    case customExerciseAdded
}

// MARK: - Domain Results

enum BuildWorkoutDomainResult: Equatable {
    case loaded(BuildWorkoutDomain)
    case dialog(type: BuildWorkoutDialog, domain: BuildWorkoutDomain)
    case error
    case exit(BuildWorkoutDomain)
    case exitEdit(BuildWorkoutDomain)
}

// MARK: - Interactor

final class BuildWorkoutInteractor {
    private let service: BuildWorkoutServiceType
    private let nameState: NameWorkoutNavigationState
    private let creationDate: Date // Used for the workout's id
    private let saveAction: ((Workout) -> Void)? // Custom override save action
    private var savedDomain: BuildWorkoutDomain?
    private var allExercises: [String: AvailableExercise]? // Used when we cancel a search
    // Used to quickly update the shown group number for each selected exercise
    private var selectedExerciseIds: Swift.Set<String> = []
    
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
            return handleCreateSuperset()
        case .cancelSuperset:
            return handleCancelSuperset()
        case .saveSuperset:
            return handleSaveSuperset()
        case .nextTapped:
            return handleNextTapped()
        case .backTapped(let userInitiated):
            return handleBackTapped(userInitiated: userInitiated)
        case .deleteGroup(let groupIndex):
            return handleDeleteGroup(groupIndex: groupIndex)
        case .rearrangeGroups(let newOrder):
            return handleRearrangeGroups(newOrder: newOrder)
        case .customExerciseAdded:
            return handleCustomExerciseAdded()
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
    
    func handleToggleExercise(exerciseId: String) -> BuildWorkoutDomainResult {
        guard let domain = savedDomain,
              var exercise = domain.exercises[exerciseId],
              domain.builtWorkout.exerciseGroups.count > domain.currentGroup else { return .error }
        
        let currentGroup = domain.currentGroup
        
        // We remove the exercise if it does not belong in a superset and
        // it was the exercise last added
        if exercise.selectedGroups.contains(currentGroup - 1) &&
            !domain.isCreatingSuperset &&
            currentGroup > 0 &&
            domain.builtWorkout.exerciseGroups[currentGroup - 1].exercises.count == 1 {
            // Deselect the exercise from the previous group
            domain.builtWorkout.exerciseGroups.removeLast()
            domain.currentGroup -= 1
            return handleRemoveExercise(domain: domain,
                                        availableExercise: &exercise)
        }
        
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
        var domain = domain
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
        selectedExerciseIds.insert(exerciseId)
        
        domain.exercises[exerciseId] = availableExercise
        domain.builtWorkout.exerciseGroups = groups
        
        if !domain.isCreatingSuperset {
            domain = addGroupToDomain(domain)
        }
        
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
        
        if availableExercise.selectedGroups.isEmpty {
            selectedExerciseIds.remove(exerciseId)
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
    
    func handleCreateSuperset() -> BuildWorkoutDomainResult {
        guard let domain = savedDomain else { return .error  }
        
        domain.isCreatingSuperset = true
        return updateDomain(domain: domain)
    }
    
    func handleCancelSuperset() -> BuildWorkoutDomainResult {
        guard let domain = savedDomain else { return .error }
        
        // Delete all of the exercises in the current group
        var groups = domain.builtWorkout.exerciseGroups
        let currentGroup = domain.currentGroup
        
        guard currentGroup < groups.count else { return .error }
        groups[currentGroup] = ExerciseGroup(exercises: [])
        
        // Remove the selected group number from each of the available exercises
        var availableExercises = domain.exercises
        let selectedExerciseIdsCopy = selectedExerciseIds
        
        for selectedExerciseId in selectedExerciseIdsCopy {
            guard var exercise = availableExercises[selectedExerciseId] else { continue }
            
            exercise.selectedGroups.removeAll { $0 == currentGroup }
            
            if exercise.selectedGroups.isEmpty {
                selectedExerciseIds.remove(selectedExerciseId)
            }
            
            availableExercises[selectedExerciseId] = exercise
            allExercises?[selectedExerciseId] = exercise
        }
        
        domain.builtWorkout.exerciseGroups = groups
        domain.exercises = availableExercises
        domain.isCreatingSuperset = false
        
        return updateDomain(domain: domain)
    }
    
    func handleSaveSuperset() -> BuildWorkoutDomainResult {
        guard var domain = savedDomain else { return .error }
        
        domain.isCreatingSuperset = false
        domain = addGroupToDomain(domain)
        
        return updateDomain(domain: domain)
    }
    
    func handleNextTapped() -> BuildWorkoutDomainResult {
        guard let domain = savedDomain else { return .error }
        
        // Just remove the last group since that will be empty
        domain.builtWorkout.exerciseGroups.removeLast()
        domain.currentGroup -= 1
        
        return updateDomain(domain: domain)
    }
    
    func handleBackTapped(userInitiated: Bool) -> BuildWorkoutDomainResult {
        guard var domain = savedDomain else { return .error }
        
        // If this happens progmatically, no need to add a group
        if userInitiated {
            domain = addGroupToDomain(domain)
        }
        
        return updateDomain(domain: domain)
    }
    
    func handleDeleteGroup(groupIndex: Int) -> BuildWorkoutDomainResult {
        guard var domain = savedDomain else { return .error }
        
        var groups = domain.builtWorkout.exerciseGroups
        var availableExercises = domain.exercises
        guard groupIndex < groups.count else { return .error }
        
        groups.remove(at: groupIndex)
        let selectedExerciseIdsCopy = selectedExerciseIds
        
        for exerciseId in selectedExerciseIdsCopy {
            guard var availableExercise = availableExercises[exerciseId] else { continue }
            
            let newSelectedGroups = availableExercise.selectedGroups.compactMap { oldGroupIndex in
                if oldGroupIndex < groupIndex {
                    return oldGroupIndex
                } else if oldGroupIndex == groupIndex {
                    return nil
                } else {
                    return oldGroupIndex - 1
                }
            }
            
            if newSelectedGroups.isEmpty {
                selectedExerciseIds.remove(exerciseId)
            }
            availableExercise.selectedGroups = newSelectedGroups
            availableExercises[exerciseId] = availableExercise
            allExercises?[exerciseId] = availableExercise
        }
        
        domain.builtWorkout.exerciseGroups = groups
        domain.exercises = availableExercises
        domain.currentGroup -= 1
        
        if groups.isEmpty {
            domain = addGroupToDomain(domain)
            return updateDomain(domain: domain, exitEdit: true)
        }
        
        return updateDomain(domain: domain)
    }
    
    func handleRearrangeGroups(newOrder: [Int]) -> BuildWorkoutDomainResult {
        guard let domain = savedDomain else { return .error }
        
        // New lists of indexes that we want the current groups to be in
        var groups = domain.builtWorkout.exerciseGroups
        var availableExercises = domain.exercises
        
        groups = newOrder.map { groups[$0] }
        
        // Update the selected group numbers for each of the selected exercises
        for exerciseId in selectedExerciseIds {
            guard var availableExercise = availableExercises[exerciseId] else { continue }
            
            var selectedGroups = availableExercise.selectedGroups
            let oldSelectedGroups = selectedGroups
            
            for (listIndex, oldGroupIndex) in oldSelectedGroups.enumerated() {
                guard let newGroupIndex = newOrder.firstIndex(of: oldGroupIndex) else { continue }
                selectedGroups[listIndex] = newGroupIndex
            }
            
            availableExercise.selectedGroups = selectedGroups
            availableExercises[exerciseId] = availableExercise
            allExercises?[exerciseId] = availableExercise
        }
        
        domain.builtWorkout.exerciseGroups = groups
        domain.exercises = availableExercises
        
        return updateDomain(domain: domain)
    }
    
    func handleCustomExerciseAdded() -> BuildWorkoutDomainResult {
        guard let domain = savedDomain else { return .error }
        
        // Just update the list of exercise to have the new custom exercise
        do {
            let updatedExercises = try service.reloadCache()
            
            domain.exercises = updatedExercises
            allExercises = updatedExercises
            
            // Ensures the new exercise pops up with the search text
            return filterExercises(domain: domain)
        } catch {
            return .error
        }
    }
}

// MARK: - Other Private Helpers

private extension BuildWorkoutInteractor {
    
    /// Updates and saves the domain object. Note: most of the arguments are nil so that we only have to update what we want.
    /// - Parameters:
    ///   - domain: The saved domain object (not nil)
    ///   - exercises: The available exercises to update
    ///   - groups: The exercise groups to update
    ///   - exitEdit: Whether or not this update should exit the edit sets/reps view
    /// - Returns: The loaded domain state after updating the saved domain object
    func updateDomain(domain: BuildWorkoutDomain, exitEdit: Bool = false) -> BuildWorkoutDomainResult {
        let groups = domain.builtWorkout.exerciseGroups
        
        domain.canSave = !groups.isEmpty &&
        !groups[0].exercises.isEmpty &&
        !domain.isCreatingSuperset
        
        savedDomain = domain
        
        if exitEdit {
            return .exitEdit(domain)
        }
        
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
    
    /// Adds an empty exercixse group to the given domain.
    /// - Parameter currentDomain: The domain to add an exercise group to
    /// - Returns: A domain identical to the given one, except with an added exercise group
    func addGroupToDomain(_ currentDomain: BuildWorkoutDomain) -> BuildWorkoutDomain {
        // Create a new empty group
        let newGroup = ExerciseGroup(exercises: [])
        
        var groups = currentDomain.builtWorkout.exerciseGroups
        groups.append(newGroup)
        // Set current group to the added group
        let currentGroup = groups.count - 1 // Zero-indexed
        
        currentDomain.builtWorkout.exerciseGroups = groups
        currentDomain.currentGroup = currentGroup
        
        return currentDomain
    }
}
