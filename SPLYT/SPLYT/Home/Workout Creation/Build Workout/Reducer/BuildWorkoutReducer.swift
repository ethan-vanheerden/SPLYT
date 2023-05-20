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
    private let workoutReducer = WorkoutReducer()
    
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
        }
    }
}

// MARK: - Private

private extension BuildWorkoutReducer {
    func getDisplay(domain: BuildWorkoutDomain, dialog: BuildWorkoutDialog? = nil) -> BuildWorkoutDisplay {
        let groups = workoutReducer.reduceExerciseGroups(groups: domain.builtWorkout.exerciseGroups)
        let groupTitles = workoutReducer.getGroupTitles(workout: domain.builtWorkout)
        let currentGroup = domain.currentGroup
        let numExercisesInCurrentGroup = groups[currentGroup].count
        let lastGroupEmpty = groups.last?.isEmpty ?? true
        let canSave = groups[0].count > 0 // We can save if there is at least one exercise
        
        let display = BuildWorkoutDisplay(allExercises: getExerciseTileStates(exerciseMap: domain.exercises),
                                          groups: groups,
                                          currentGroup: currentGroup,
                                          currentGroupTitle: getCurrentGroupTitle(numExercisesInCurrentGroup),
                                          groupTitles: groupTitles,
                                          lastGroupEmpty: lastGroupEmpty,
                                          showDialog: dialog,
                                          backDialog: backDialog,
                                          saveDialog: saveDialog,
                                          canSave: canSave)
        return display
    }
    
    func getExerciseTileStates(exerciseMap: [String: AvailableExercise]) -> [AddExerciseTileViewState] {
        return exerciseMap.values.map {
            AddExerciseTileViewState(id: $0.id,
                                     exerciseName: $0.name,
                                     isSelected: $0.isSelected,
                                     isFavorite: $0.isFavorite)
        }.sorted {
            // Maps don't preserve sorted order, so we must sort
            // TODO: In the future, we can add other custom sorting comparisons here (ex: by favorite, recent, etc.)
            $0.exerciseName < $1.exerciseName
        }
    }
    
    func getCurrentGroupTitle(_ numExercises: Int) -> String {
        let exercisePlural = numExercises == 1 ? Strings.exercise : Strings.exercises
        return Strings.currentGroup + ": \(numExercises) \(exercisePlural)"
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
}
