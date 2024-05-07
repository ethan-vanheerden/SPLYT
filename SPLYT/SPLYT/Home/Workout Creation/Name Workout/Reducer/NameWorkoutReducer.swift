//
//  NameWorkoutReducer.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 6/16/23.
//

import Foundation
import DesignSystem
import ExerciseCore

struct NameWorkoutReducer {
    func reduce(_ domain: NameWorkoutDomainResult) -> NameWorkoutViewState {
        switch domain {
        case .error:
            return .error
        case .loaded(let domain):
            let display = getDisplay(domain: domain)
            return .loaded(display)
        }
    }
}

// MARK: - Private

private extension NameWorkoutReducer {
    func getDisplay(domain: NameWorkoutDomain) -> NameWorkoutDisplay {
        return NameWorkoutDisplay(navBar: getNavBar(routineType: domain.routineType),
                                  workoutName: domain.workoutName,
                                  textEntry: getTextEntry(routineType: domain.routineType),
                                  routineType: domain.routineType,
                                  nextButtonEnabled: !domain.workoutName.isEmpty)
    }
    
    func getNavBar(routineType: RoutineType) -> NavigationBarViewState {
        let title: String
        switch routineType {
        case .workout:
            title = Strings.createWorkout
        case .plan:
            title = Strings.createPlan
        }
        
        return NavigationBarViewState(title: title)
    }
    
    func getTextEntry(routineType: RoutineType) -> TextEntryViewState {
        let title: String
        let placeholder: String
        switch routineType {
        case .workout:
            title = Strings.workoutName
            placeholder = Strings.enterWorkoutName
        case .plan:
            title = Strings.planName
            placeholder = Strings.enterPlanName
        }
        
        return TextEntryViewState(title: title,
                                  placeholder: placeholder,
                                  capitalization: .everyWord)
    }
}

// MARK: - Strings

fileprivate struct Strings {
    static let createWorkout = "CREATE WORKOUT"
    static let createPlan = "CREATE PLAN"
    static let workoutName = "Workout Name"
    static let planName = "Plan Name"
    static let enterWorkoutName = "Enter a workout name"
    static let enterPlanName = "Enter a plan name"
}
