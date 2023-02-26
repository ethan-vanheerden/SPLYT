//
//  BuildWorkoutReducer.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 1/18/23.
//

import Foundation
import DesignSystem

struct BuildWorkoutReducer {
    func reduce(_ domain: BuildWorkoutDomainResult) -> BuildWorkoutViewState {
        switch domain {
        case .loaded(let domainObject):
            return reduceLoaded(domain: domainObject)
        case .dialog(let domainObject):
            return reduceLoaded(domain: domainObject, dialogOpen: true)
        case .error:
            return .error
        }
    }
}

// MARK: - Private

private extension BuildWorkoutReducer {
    func reduceLoaded(domain: BuildWorkoutDomainObject, dialogOpen: Bool = false) -> BuildWorkoutViewState {
        let availableExercises: [AddExerciseTileViewState] = domain.exercises.map {
            AddExerciseTileViewState(id: $0.id,
                                     exerciseName: $0.name,
                                     isSelected: $0.isSelected,
                                     isFavorite: $0.isFavorite)
        }
        
        var groups = [[BuildExerciseViewState]]()
        
        for group in domain.builtWorkout.exerciseGroups {
            // For each group, get the BuildExerciseViewStates of the exercises in it
            let exercises = getBuildExerciseStates(exercises: group.exercises)
            groups.append(exercises)
        }
        
        let currentGroup = domain.currentGroup
        let numExercisesInCurrentGroup = groups[currentGroup].count
        let lastGroupEmpty = groups.last?.isEmpty ?? true
        
        let display = BuildWorkoutDisplay(allExercises: availableExercises,
                                          groups: groups,
                                          currentGroup: currentGroup,
                                          currentGroupTitle: getCurrentGroupTitle(numExercisesInCurrentGroup),
                                          groupTitles: getGroupTitles(workout: domain.builtWorkout),
                                          lastGroupEmpty: lastGroupEmpty,
                                          dialogOpen: dialogOpen,
                                          dialog: getDialog())
        return .main(display)
    }
    
    func getGroupTitles(workout: Workout) -> [String] {
        var titles = [String]()
        
        // We can assume that there is always at least one group
        for i in 1...workout.exerciseGroups.count {
            titles.append(Strings.group + " \(i)")
        }
        
        return titles
    }
    
    func getBuildExerciseStates(exercises: [Exercise]) -> [BuildExerciseViewState] {
        return exercises.map { exercise in
            let headerState = SectionHeaderViewState(id: exercise.name,
                                                     text: exercise.name)
            return BuildExerciseViewState(id: exercise.id,
                                          header: headerState,
                                          sets: getSetStates(exercise: exercise))
        }
    }
    
    func getSetStates(exercise: Exercise) -> [SetViewState] {
        return exercise.sets.enumerated().map { index, set in
            SetViewState(id: set.id,
                         title: Strings.set + " \(index + 1)",
                         type: getSetViewType(set.inputType))
        }
    }
    
    func getSetViewType(_ input: SetInputType) -> SetViewType {
        switch input {
        case .repsWeight:
            return .repsWeight(weightTitle: Strings.lbs, repsTitle: Strings.reps)
        case .repsOnly:
            return .repsOnly(title: Strings.reps)
        case .time:
            return .time(title: Strings.sec)
        }
    }
    
    func getCurrentGroupTitle(_ numExercises: Int) -> String {
        let exercisePlural = numExercises == 1 ? Strings.exercise : Strings.exercises
        return Strings.currentGroup + ": \(numExercises) \(exercisePlural)"
    }
    
    func getDialog() -> DialogViewState {
        return DialogViewState(title: Strings.dialogTitle,
                               subtitle: Strings.dialogSubtitle,
                               primaryButtonTitle: Strings.dialogPrimaryTitle,
                               secondaryButtonTitle: Strings.dialogSecondaryTitle)
    }
}

fileprivate struct Strings {
    static let group = "Group"
    static let set = "Set"
    static let lbs = "lbs"
    static let reps = "reps"
    static let sec = "sec"
    static let exercise = "exercise"
    static let exercises = "exercises"
    static let currentGroup = "Current group"
    static let dialogTitle = "Confirm Exit"
    static let dialogSubtitle = "If you exit now, all progress will be lost."
    static let dialogPrimaryTitle = "Confirm"
    static let dialogSecondaryTitle = "Cancel"
}
