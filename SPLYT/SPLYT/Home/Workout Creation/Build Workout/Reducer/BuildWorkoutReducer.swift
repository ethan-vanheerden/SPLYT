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
        }
    }
}

// MARK: - Private

private extension BuildWorkoutReducer {
    func getDisplay(domain: BuildWorkoutDomain, dialog: BuildWorkoutDialog? = nil) -> BuildWorkoutDisplay {
        var groups = [[BuildExerciseViewState]]()
        
        for group in domain.builtWorkout.exerciseGroups {
            // For each group, get the BuildExerciseViewStates of the exercises in it
            let exercises = getBuildExerciseStates(exercises: group.exercises)
            groups.append(exercises)
        }
        
        let currentGroup = domain.currentGroup
        let numExercisesInCurrentGroup = groups[currentGroup].count
        let lastGroupEmpty = groups.last?.isEmpty ?? true
        let canSave = groups[0].count > 0 // We can save if there is at least one exercise
        
        let display = BuildWorkoutDisplay(allExercises: getExerciseTileStates(exerciseMap: domain.exercises),
                                          groups: groups,
                                          currentGroup: currentGroup,
                                          currentGroupTitle: getCurrentGroupTitle(numExercisesInCurrentGroup),
                                          groupTitles: getGroupTitles(workout: domain.builtWorkout),
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
            let headerState = SectionHeaderViewState(text: exercise.name)
            return BuildExerciseViewState(header: headerState,
                                          sets: getSetStates(exercise: exercise),
                                          canRemoveSet: exercise.sets.count > 1)
        }
    }
    
    func getSetStates(exercise: Exercise) -> [SetViewState] {
        return exercise.sets.enumerated().map { index, set in
            SetViewState(setIndex: index,
                         title: Strings.set + " \(index + 1)",
                         type: getSetViewType(set.input),
                         modifier: getSetModifierState(modifier: set.modifier))
        }
    }
    
    func getSetViewType(_ input: SetInput) -> SetInputViewState {
        switch input {
        case let .repsWeight(reps, weight):
            return .repsWeight(weightTitle: Strings.lbs,
                               weight: weight,
                               repsTitle: Strings.reps,
                               reps: reps)
        case .repsOnly(let reps):
            return .repsOnly(title: Strings.reps, reps: reps)
        case .time(let seconds):
            return .time(title: Strings.sec, seconds: seconds)
        }
    }
    
    func getSetModifierState(modifier: SetModifier?) -> SetModifierViewState? {
        guard let modifier = modifier else { return nil }
        
        switch modifier {
        case .dropSet(let input):
            return .dropSet(set: getSetViewType(input))
        case .restPause(let input):
            return .restPause(set: getSetViewType(input))
        case .eccentric:
            return .eccentric
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
    static let group = "Group"
    static let set = "Set"
    static let lbs = "lbs"
    static let reps = "reps"
    static let sec = "sec"
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
