//
//  WorkoutDetailsReducer.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 7/20/23.
//

import Foundation
import DesignSystem
import ExerciseCore

struct WorkoutDetailsReducer {
    func reduce(_ domain: WorkoutDetailsDomainResult) -> WorkoutDetailsViewState {
        switch domain {
        case .error:
            return .error
        case .loaded(let domain):
            let display = getDisplay(domain: domain)
            return .loaded(display)
        case let .dialog(dialog, domain):
            let display = getDisplay(domain: domain, dialog: dialog)
            return .loaded(display)
        case .exit(let domain):
            let display = getDisplay(domain: domain)
            return .exit(display)
        }
    }
}

// MARK: - Private

private extension WorkoutDetailsReducer {
    func getDisplay(domain: WorkoutDetailsDomain,
                    dialog: WorkoutDetailsDialog? = nil) -> WorkoutDetailsDisplay {
        let workout = domain.workout
        let workoutName = WorkoutReducer.getWorkoutAndPlanName(workout: workout)
        let numExercisesTitle = WorkoutReducer.getNumExercisesTitle(workout: workout)
        let completedTitle = WorkoutReducer.getLastCompletedTitle(date: workout.lastCompleted,
                                                                  isHistory: true)
        let groups = getCompletedGroupStates(workout: workout)
        
        let display = WorkoutDetailsDisplay(workoutName: workoutName,
                                            numExercisesTitle: numExercisesTitle,
                                            completedTitle: completedTitle ?? "",
                                            groups: groups,
                                            expandedGroups: domain.expandedGroups,
                                            presentedDialog: dialog,
                                            deleteDialog: HistoryDialogViewStates.deleteWorkoutHistory)
        
        return display
    }
    
    func getCompletedGroupStates(workout: Workout) -> [CompletedExerciseGroupViewState] {
        var result = [CompletedExerciseGroupViewState]()
        let groups = WorkoutReducer.reduceCompletedExerciseGroups(groups: workout.exerciseGroups)
        let groupTitles = WorkoutReducer.getGroupTitles(workout: workout)
        
        for (index, exercises) in groups.enumerated() {
            let header = CollapseHeaderViewState(title: groupTitles[index])
            let newGroupState = CompletedExerciseGroupViewState(header: header,
                                                                exercises: exercises)
            result.append(newGroupState)
        }
        
        return result
    }
}
