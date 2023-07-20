//
//  HistoryReducer.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 7/16/23.
//

import Foundation
import DesignSystem
import ExerciseCore

struct HistoryReducer {
    func reduce(_ domain: HistoryDomainResult) -> HistoryViewState {
        switch domain {
        case .error:
            return .error
        case .loaded(let domain):
            let display = getDisplay(domain: domain)
            return .loaded(display)
        case let .dialog(dialog, domain):
            let display = getDisplay(domain: domain, dialog: dialog)
            return .loaded(display)
        }
    }
}

// MARK: - Private

private extension HistoryReducer {
    func getDisplay(domain: HistoryDomain, dialog: HistoryDialog? = nil) -> HistoryDisplay {
        let workouts = getHistoryTileStates(histories: domain.workouts)
        
        let display = HistoryDisplay(workouts: workouts,
                                     presentedDialog: dialog,
                                     deleteWorkoutHistoryDialog: deleteWorkoutHistoryDialog)
        
        return display
    }
    
    func getHistoryTileStates(histories: [WorkoutHistory]) -> [RoutineTileViewState] {
        return histories.map { history in
            let workout = history.workout
            let tileTitle = getTileTitle(workoutName: workout.name, planName: workout.planName)
            let numExercisesTitle = WorkoutReducer.getNumExercisesTitle(workout: workout)
            let lastCompletedTitle = WorkoutReducer.getLastCompletedTitle(date: workout.lastCompleted,
                                                                          isHistory: true)
            
            return RoutineTileViewState(id: history.id, // Use the history id instead of the workout id
                                        title: tileTitle,
                                        subtitle: numExercisesTitle,
                                        lastCompletedTitle: lastCompletedTitle)
        }
    }
    
    private func getTileTitle(workoutName: String, planName: String?) -> String {
        var planTitle = ""
        if let planName = planName {
            planTitle = " | \(planName)"
        }
        
        return workoutName + planTitle
    }
    
    var deleteWorkoutHistoryDialog: DialogViewState {
        return .init(title: Strings.deleteWorkoutHistory,
                     subtitle: Strings.deleteThisVersion,
                     primaryButtonTitle: Strings.delete,
                     secondaryButtonTitle: Strings.cancel)
    }
}

// MARK: - Strings

fileprivate struct Strings {
    static let deleteWorkoutHistory = "Delete workout history?"
    static let deleteThisVersion = "This will delete only this completed version of the workout. This action can't be undone."
    static let delete = "Delete"
    static let cancel = "Cancel"
    static let completed = "Completed"
}
