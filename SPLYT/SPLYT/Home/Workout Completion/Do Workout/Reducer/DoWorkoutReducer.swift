//
//  DoWorkoutReducer.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 5/17/23.
//

import Foundation
import DesignSystem

struct DoWorkoutReducer {
    private let workoutReducer = WorkoutReducer()
    
    func reduce(_ domain: DoWorkoutDomainResult) -> DoWorkoutViewState {
        switch domain {
        case .error:
            return .error
        case .loaded(let domain):
            return reduceLoaded(domain: domain)
        }
    }
}

// MARK: - Private

private extension DoWorkoutReducer {
    
    func reduceLoaded(domain: DoWorkoutDomain) -> DoWorkoutViewState {
        let groups = workoutReducer.reduceExerciseGroups(groups: domain.workout.exerciseGroups,
                                                         includeHeaderLine: false)
        let groupTitles = workoutReducer.getGroupTitles(workout: domain.workout)
        
        let display = DoWorkoutDisplay(workoutName: domain.workout.name,
                                       groups: groups,
                                       groupTitles: groupTitles,
                                       inCountdown: domain.inCountdown,
                                       isResting: domain.isResting)
        return .loaded(display)
    }
}
