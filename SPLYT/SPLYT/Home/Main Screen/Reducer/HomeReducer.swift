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
        NavigationBarViewState(id: "workouts-navbar", // TODO: this doesn't need an id at all
                               title: Strings.home,
                               position: .left)
    }
    
    var segmentedControlTitles: [String] {
        [Strings.workouts, Strings.plans]
    }
    
    func getCreatedWorkouts(workouts: [Workout]) -> [CreatedWorkoutViewState] {
        return workouts.map {
            CreatedWorkoutViewState(id: "0", // FIXME
                                    title: $0.name,
                                    subtitle: "TODO num exercises",
                                    lastCompleted: "TODO parse date")
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
}

// MARK: - Strings

fileprivate struct Strings {
    static let createPlan = "CREATE NEW PLAN"
    static let createWorkout = "CREATE NEW WORKOUT"
    static let home = "Home"
    static let workouts = "WORKOUTS"
    static let plans = "PLANS"
    
}
