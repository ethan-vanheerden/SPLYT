//
//  NameWorkoutReducer.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 6/16/23.
//

import Foundation
import DesignSystem

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
        return NameWorkoutDisplay(navBar: getNavBar(buildType: domain.buildType),
                                  workoutName: domain.workoutName,
                                  textEntry: getTextEntry(buildType: domain.buildType),
                                  buildType: domain.buildType,
                                  nextButtonEnabled: !domain.workoutName.isEmpty)
    }
    
    func getNavBar(buildType: BuildWorkoutType) -> NavigationBarViewState {
        let title: String
        switch buildType {
        case .workout:
            title = Strings.createWorkout
        case .plan:
            title = Strings.createPlan
        }
        
        return NavigationBarViewState(title: title)
    }
    
    func getTextEntry(buildType: BuildWorkoutType) -> TextEntryViewState {
        let title: String
        let placeholder: String
        switch buildType {
        case .workout:
            title = Strings.workoutName
            placeholder = Strings.enterWorkoutName
        case .plan:
            title = Strings.planName
            placeholder = Strings.enterPlanName
        }
        
        return TextEntryViewState(title: title,
                                  placeholder: placeholder)
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
