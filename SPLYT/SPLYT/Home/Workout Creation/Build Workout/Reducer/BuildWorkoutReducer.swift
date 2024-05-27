//
//  BuildWorkoutReducer.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 1/18/23.
//

import Foundation
import DesignSystem
import ExerciseCore

struct BuildWorkoutReducer {
    func reduce(_ domain: BuildWorkoutDomainResult) -> BuildWorkoutViewState {
        switch domain {
        case .loaded(let domain):
            let display = getDisplay(domain: domain)
            return .main(display)
        case let .dialog(type, domain):
            let display = getDisplay(domain: domain, dialog: type)
            return .main(display)
        case .error:
            return .error
        case .exit(let domain):
            let display = getDisplay(domain: domain)
            return .exit(display)
        case .exitEdit(let domain):
            let display = getDisplay(domain: domain)
            return .exitEdit(display)
        }
    }
}

// MARK: - Private

private extension BuildWorkoutReducer {
    func getDisplay(domain: BuildWorkoutDomain, dialog: BuildWorkoutDialog? = nil) -> BuildWorkoutDisplay {
        let groups = WorkoutReducer.reduceExerciseGroups(groups: domain.builtWorkout.exerciseGroups)
        let groupTitles = WorkoutReducer.getGroupTitles(workout: domain.builtWorkout)
        let currentGroup = domain.currentGroup
        let numExercisesInCurrentGroup = groups[currentGroup].count
        let lastGroupEmpty = groups.last?.isEmpty ?? true
        
        let supersetDisplay = SupersetDisplay(isCreatingSuperset: domain.isCreatingSuperset,
                                              currentSupersetTitle: getCurrentSupersetTitle(numExercisesInCurrentGroup),
                                              canSave: domain.canSaveSuperset)
        
        let display = BuildWorkoutDisplay(allExercises: getExerciseTileStates(exerciseMap: domain.exercises),
                                          groups: groups,
                                          currentGroup: currentGroup,
                                          groupTitles: groupTitles,
                                          lastGroupEmpty: lastGroupEmpty,
                                          showDialog: dialog,
                                          backDialog: backDialog,
                                          saveDialog: saveDialog,
                                          canSave: domain.canSave,
                                          filterDisplay: getFilterDisplay(filterDomain: domain.filterDomain),
                                          isFiltering: getIsFiltering(filterDomain: domain.filterDomain),
                                          supersetDisplay: supersetDisplay)
        return display
    }
    
    func getExerciseTileStates(exerciseMap: [String: AvailableExercise]) -> [AddExerciseTileSectionViewState] {
        let exercises = exerciseMap.values.map {
            AddExerciseTileViewState(id: $0.id,
                                     exerciseName: $0.name,
                                     selectedGroups: $0.selectedGroups,
                                     isFavorite: $0.isFavorite)
        }
        return partitionTileStates(exercises: exercises)
    }
    
    var backDialog: DialogViewState {
        return DialogViewState(title: Strings.confirmExit,
                               subtitle: Strings.exitNow,
                               primaryButtonTitle: Strings.confirm,
                               secondaryButtonTitle: Strings.cancel)
    }
    
    var saveDialog: DialogViewState {
        return DialogViewState(title: Strings.errorSaving,
                               subtitle: Strings.tryAgain,
                               primaryButtonTitle: Strings.ok)
    }
    
    
    /// Constructs the sectioned `AddExerciseTileViewStates` so that each section's exercise starts with the same letter.
    /// - Parameter exercises: the `AddExerciseTileViewStates` to section off
    /// - Returns: the `AddExerciseTileSectionViewState` for the exercises
    func partitionTileStates(exercises: [AddExerciseTileViewState]) -> [AddExerciseTileSectionViewState] {
        // This creates a dictionary where the keys are a letter and the values are the
        // exercise states which start with that letter
        let groupedItems: [String: [AddExerciseTileViewState]] = Dictionary(grouping: exercises) {
            $0.exerciseName.first?.uppercased() ?? ""
        }
        let sortedKeys = groupedItems.keys.sorted(by: <)
        var sections = [AddExerciseTileSectionViewState]()
        
        for key in sortedKeys {
            guard let exercises = groupedItems[key] else { continue }
            let sortedExercises = exercises.sorted { $0.exerciseName < $1.exerciseName }
            let header = SectionHeaderViewState(title: key)
            let section = AddExerciseTileSectionViewState(header: header,
                                                          exercises: sortedExercises)
            sections.append(section)
        }
        
        return sections
    }
    
    func getFilterDisplay(filterDomain: BuildWorkoutFilterDomain) -> BuildWorkoutFilterDisplay {
        return .init(isFavorite: filterDomain.isFavorite,
                     musclesWorked: filterDomain.musclesWorked)
    }
    
    func getIsFiltering(filterDomain: BuildWorkoutFilterDomain) -> Bool {
        return filterDomain.isFavorite || filterDomain.musclesWorked.values.contains(true)
    }
    
    func getCurrentSupersetTitle(_ numExercises: Int) -> String {
        let exercisePlural = numExercises == 1 ? Strings.exercise : Strings.exercises
        return "\(numExercises) \(exercisePlural) " + Strings.inSuperset
    }
}

// MARK: - Strings

fileprivate struct Strings {
    static let exercise = "exercise"
    static let exercises = "exercises"
    static let currentGroup = "Current group"
    static let confirmExit = "Confirm Exit"
    static let exitNow = "If you exit now, all progress will be lost."
    static let confirm = "Confirm"
    static let cancel = "Cancel"
    static let errorSaving = "Error saving"
    static let tryAgain = "Please try again later."
    static let ok = "Ok"
    static let inSuperset = "in Superset"
}
