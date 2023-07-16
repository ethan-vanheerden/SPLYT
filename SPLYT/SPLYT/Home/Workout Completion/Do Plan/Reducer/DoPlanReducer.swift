//
//  DoPlanReducer.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 7/4/23.
//

import Foundation
import DesignSystem
import ExerciseCore

struct DoPlanReducer {
    func reduce(_ domain: DoPlanDomainResult) -> DoPlanViewState {
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

private extension DoPlanReducer {
    func getDisplay(domain: DoPlanDomain) -> DoPlanDisplay {
        let navBar = getNavBar(planName: domain.plan.name)
        let workoutTiles = WorkoutReducer.createWorkoutRoutineTiles(workouts: domain.plan.workouts)
        
        let display = DoPlanDisplay(navBar: navBar,
                                    workouts: workoutTiles)
        
        return display
    }
    
    func getNavBar(planName: String) -> NavigationBarViewState {
        return .init(title: planName)
    }
}
