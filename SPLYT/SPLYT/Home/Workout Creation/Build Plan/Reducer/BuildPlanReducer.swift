//
//  BuildPlanReducer.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 6/18/23.
//

import Foundation
import DesignSystem
import ExerciseCore

struct BuildPlanReducer {
    func reduce(_ domain: BuildPlanDomainResult) -> BuildPlanViewState {
        switch domain {
        case .error:
            return .error
        case .loaded(let domain):
            let display = getDisplay(domain: domain, dialog: nil)
            return .loaded(display)
        case let .dialog(dialog, domain):
            let display = getDisplay(domain: domain, dialog: dialog)
            return .loaded(display)
        case .exit(let domain):
            let display = getDisplay(domain: domain, dialog: nil)
            return .exit(display)
        }
    }
}

// MARK: - Private

private extension BuildPlanReducer {
    func getDisplay(domain: BuildPlanDomain, dialog: BuildPlanDialog?) -> BuildPlanDisplay {
        let workouts = getWorkoutTileStates(workouts: domain.builtPlan.workouts)
        
        let display = BuildPlanDisplay(workouts: workouts,
                                       canSave: domain.canSave,
                                       presentedDialog: dialog,
                                       backDialog: backDialog,
                                       saveDialog: saveDialog,
                                       deleteDialog: deleteDialog)
        return display
    }
    
    private func getWorkoutTileStates(workouts: [Workout]) -> [RoutineTileViewState] {
        return workouts.map { workout in
            let numExercisesTitle = WorkoutReducer.getNumExercisesTitle(workout: workout)
            
            return RoutineTileViewState(id: workout.id,
                                        title: workout.name,
                                        subtitle: numExercisesTitle)
            
        }
    }
    
    var backDialog: DialogViewState {
        return .init(title: Strings.confirmExit,
                     subtitle: Strings.exitNow,
                     primaryButtonTitle: Strings.confirm,
                     secondaryButtonTitle: Strings.cancel)
    }
    
    var saveDialog: DialogViewState {
        return .init(title: Strings.savePlan,
                     subtitle: Strings.planSaved,
                     primaryButtonTitle: Strings.confirm,
                     secondaryButtonTitle: Strings.cancel)
    }
    
    var deleteDialog: DialogViewState {
        return DialogViewState(title: Strings.deleteWorkout,
                               subtitle: Strings.cantBeUndone,
                               primaryButtonTitle: Strings.delete,
                               secondaryButtonTitle: Strings.cancel)
    }
}

// MARK: - Strings

fileprivate struct Strings {
    static let confirmExit = "Confirm Exit"
    static let exitNow = "If you exit now, all progress will be lost."
    static let confirm = "Confirm"
    static let cancel = "Cancel"
    static let savePlan = "Save Plan?"
    static let planSaved = "Your plan will be saved to your routines."
    static let deleteWorkout = "Delete workout?"
    static let cantBeUndone = "This action can't be undone."
    static let delete = "Delete"
}
