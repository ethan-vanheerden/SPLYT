//
//  DoWorkoutReducer.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 5/17/23.
//

import Foundation
import DesignSystem

struct DoWorkoutReducer {
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
        let progressBar = getProgressBar(fractionCompleted: domain.fractionCompleted)
        let groupTitles = WorkoutReducer.getGroupTitles(workout: domain.workout)
        let groups = getExerciseGroupStates(domain: domain, groupTitles: groupTitles)
        
        let display = DoWorkoutDisplay(workoutName: domain.workout.name,
                                       progressBar: progressBar,
                                       groupTitles: groupTitles,
                                       groups: groups,
                                       expandedGroups: domain.expandedGroups,
                                       inCountdown: domain.inCountdown,
                                       isResting: domain.isResting)
        return .loaded(display)
    }
    
    func getProgressBar(fractionCompleted: Double) -> ProgressBarViewState {
        return ProgressBarViewState(fractionCompleted: fractionCompleted,
                                    color: .lightBlue,
                                    outlineColor: .lightBlue)
    }
    
    func getExerciseGroupStates(domain: DoWorkoutDomain, groupTitles: [String]) -> [DoExerciseGroupViewState] {
        var result = [DoExerciseGroupViewState]()
        let groups = WorkoutReducer.reduceExerciseGroups(groups: domain.workout.exerciseGroups,
                                                         includeHeaderLine: false)
        
        for (index, exercises) in groups.enumerated() {
            let header = CollapseHeaderViewState(title: groupTitles[index],
                                                 color: .lightBlue,
                                                 isComplete: domain.completedGroups[index])
            let slider = getSlider(isComplete: domain.completedGroups[index])
            
            let state = DoExerciseGroupViewState(header: header,
                                                 exercises: exercises,
                                                 slider: slider)
            result.append(state)
        }
        
        return result
    }
    
    func getSlider(isComplete: Bool) -> ActionSliderViewState? {
        var slider: ActionSliderViewState?
        
        if !isComplete {
            slider = ActionSliderViewState(sliderColor: .lightBlue,
                                           backgroundText: Strings.markAsComplete)
        }
        
        return slider
    }
}

fileprivate struct Strings {
    static let markAsComplete = "Mark as complete"
}
