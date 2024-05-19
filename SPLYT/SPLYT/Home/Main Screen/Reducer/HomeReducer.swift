//
//  HomeReducer.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 12/24/22.
//

import Foundation
import DesignSystem
import ExerciseCore

final class HomeReducer {
    func reduce(_ domain: HomeDomainResult) -> HomeViewState {
        switch domain {
        case .error:
            return .error
        case .loaded(let domain):
            let display = getDisplay(domain: domain)
            return .main(display)
        case let .dialog(dialog, domain):
            let display = getDisplay(domain: domain, dialog: dialog)
            return .main(display)
        case .workoutInProgress:
            return .workoutInProgress
        }
    }
}

// MARK: - Private

private extension HomeReducer {
    func getDisplay(domain: HomeDomain, dialog: HomeDialog? = nil) -> HomeDisplay {
        let workoutStates = getWorkoutStates(workouts: domain.routines.workouts)
        let planStates = getPlanStates(plans: domain.routines.plans)
        
        let display = HomeDisplay(navBar: navBar,
                                  segmentedControlTitles: segmentedControlTitles,
                                  workouts: workoutStates,
                                  plans: planStates,
                                  fab: FABState,
                                  presentedDialog: dialog,
                                  deleteWorkoutDialog: deleteWorkoutDialog,
                                  deletePlanDialog: deletePlanDialog)
        return display
    }
    
    var navBar: NavigationBarViewState {
        NavigationBarViewState(title: Strings.home,
                               size: .large,
                               position: .left)
    }
    
    var segmentedControlTitles: [String] {
        [Strings.workouts, Strings.plans]
    }
    
    func getWorkoutStates(workouts: [String: Workout]) -> [RoutineTileViewState] {
        let workoutsSorted = workouts.values.sorted { $0.createdAt > $1.createdAt }
        return WorkoutReducer.createWorkoutRoutineTiles(workouts: workoutsSorted)
    }
    
    func getPlanStates(plans: [String: Plan]) -> [RoutineTileViewState] {
        return plans.values.sorted { $0.createdAt > $1.createdAt }
            .map { plan in
                let numWorkoutsTitle = WorkoutReducer.getNumWorkoutsTitle(plan: plan)
                let lastCompletedTitle = WorkoutReducer.getLastCompletedTitle(date: plan.lastCompleted)
                
                return RoutineTileViewState(id: plan.id,
                                            title: plan.name,
                                            subtitle: numWorkoutsTitle,
                                            lastCompletedTitle: lastCompletedTitle)
            }
    }
    
    var FABState: HomeFABViewState {
        let createPlanState = HomeFABRowViewState(title: Strings.createPlan,
                                                  imageName: "calendar")
        let createWorkoutState = HomeFABRowViewState(title: Strings.createWorkout,
                                                     imageName: "figure.strengthtraining.traditional")
        
        return HomeFABViewState(createPlanState: createPlanState,
                                createWorkoutState: createWorkoutState)
    }
    
    var deleteWorkoutDialog: DialogViewState {
        return DialogViewState(title: Strings.deleteWorkout,
                               subtitle: Strings.cantBeUndone,
                               primaryButtonTitle: Strings.delete,
                               secondaryButtonTitle: Strings.cancel)
    }
    
    var deletePlanDialog: DialogViewState {
        return DialogViewState(title: Strings.deletePlan,
                               subtitle: Strings.workoutsDeleted,
                               primaryButtonTitle: Strings.delete,
                               secondaryButtonTitle: Strings.cancel)
    }
}

// MARK: - Strings

fileprivate struct Strings {
    static let createPlan = "CREATE NEW PLAN"
    static let createWorkout = "CREATE NEW WORKOUT"
    static let home = "🏠 Home"
    static let workouts = "WORKOUTS"
    static let plans = "PLANS"
    static let deleteWorkout = "Delete workout?"
    static let cantBeUndone = "This action can't be undone."
    static let delete = "Delete"
    static let cancel = "Cancel"
    static let deletePlan = "Delete plan?"
    static let workoutsDeleted = "This will also delete all of the associated workouts. This action can't be undone."
}
