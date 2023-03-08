//
//  HomeReducer.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 12/24/22.
//

import Foundation
import DesignSystem

final class HomeReducer {
    func reduce(_ domain: HomeDomainResult) -> HomeViewState {
        switch domain {
        case .error:
            return .error
        case .loaded(let domain):
            return reduceLoaded(domain: domain)
        }
    }
}

// MARK: - Private

private extension HomeReducer {
    func reduceLoaded(domain: HomeDomain) -> HomeViewState {
        
        let display = HomeDisplay(navBar: navBar,
                                  segmentedControlTitles: segmentedControlTitles,
                                  workouts: getCreatedWorkouts(workouts: domain.workouts),
                                  fab: getFABState())
        return .main(display)
    }
    
    var navBar: NavigationBarViewState {
        NavigationBarViewState(title: Strings.home,
                               size: .large,
                               position: .left)
    }
    
    var segmentedControlTitles: [String] {
        [Strings.workouts, Strings.plans]
    }
    
    func getCreatedWorkouts(workouts: [Workout]) -> [CreatedWorkoutViewState] {
        return workouts.map {
            CreatedWorkoutViewState(id: $0.id,
                                    title: $0.name,
                                    subtitle: getWorkoutSubtitle(workout: $0),
                                    lastCompleted: getLastCompletedTitle(date: $0.lastCompleted))
        }
    }
    
    func getFABState() -> FABViewState {
        let createPlanState = FABRowViewState(id: "plan",
                                              title: Strings.createPlan,
                                              imageName: "calendar")
        let createWorkoutState = FABRowViewState(id: "workout",
                                                 title: Strings.createWorkout,
                                                 imageName: "figure.strengthtraining.traditional")
        
        return FABViewState(id: "fab",
                            createPlanState: createPlanState,
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
}
