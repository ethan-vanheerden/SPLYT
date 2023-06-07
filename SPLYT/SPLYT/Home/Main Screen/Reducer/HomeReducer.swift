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
        }
    }
}

// MARK: - Private

private extension HomeReducer {
    func getDisplay(domain: HomeDomain, dialog: HomeDialog? = nil) -> HomeDisplay {
        let workouts = getCreatedWorkouts(workouts: domain.workouts)
        
        let display = HomeDisplay(navBar: navBar,
                                  segmentedControlTitles: segmentedControlTitles,
                                  workouts: workouts,
                                  fab: FABState,
                                  showDialog: dialog,
                                  deleteDialog: deleteDialog)
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
    
    func getCreatedWorkouts(workouts: [CreatedWorkout]) -> [CreatedWorkoutViewState] {
        return workouts.sorted {  $0.createdAt < $1.createdAt }
            .map { createdWorkout in
                // Use the filename as the ID so we know where to look when a workout is selected
                CreatedWorkoutViewState(id: createdWorkout.filename,
                                        title: createdWorkout.workout.name,
                                        subtitle: getWorkoutSubtitle(workout: createdWorkout.workout),
                                        lastCompleted: getLastCompletedTitle(date: createdWorkout.workout.lastCompleted))
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
    
    func getWorkoutSubtitle(workout: Workout) -> String {
        var numExercises = 0
        for group in workout.exerciseGroups {
            numExercises += group.exercises.count
        }
        let exercisePlural = numExercises == 1 ? Strings.exercise : Strings.exercises
        return "\(numExercises) \(exercisePlural)"
    }
    
    func getLastCompletedTitle(date: Date?) -> String? {
        guard let date = date else { return nil }
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMMdY"
        formatter.dateStyle = .medium // Feb 3, 2023
        
        
        let dateString = formatter.string(from: date)
        return Strings.lastCompleted + " \(dateString)"
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
    static let createPlan = "CREATE NEW PLAN"
    static let createWorkout = "CREATE NEW WORKOUT"
    static let home = "Home"
    static let workouts = "WORKOUTS"
    static let plans = "PLANS"
    static let exercise = "exercise"
    static let exercises = "exercises"
    static let lastCompleted = "Last completed:"
    static let deleteWorkout = "Delete workout?"
    static let cantBeUndone = "This action can't be undone."
    static let delete = "Delete"
    static let cancel = "Cancel"
}
