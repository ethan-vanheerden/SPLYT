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
            let display = getDisplay(domain: domain)
            return .loaded(display)
        case let .dialog(dialog, domain):
            let display = getDisplay(domain: domain, dialog: dialog)
            return .loaded(display)
        case .exit(let domain):
            let display = getDisplay(domain: domain)
            return .exit(display)
        }
    }
}

// MARK: - Private

private extension DoWorkoutReducer {
    func getDisplay(domain: DoWorkoutDomain, dialog: DoWorkoutDialog? = nil) -> DoWorkoutDisplay {
        let progressBar = getProgressBar(fractionCompleted: domain.fractionCompleted)
        let groupTitles = WorkoutReducer.getGroupTitles(workout: domain.workout)
        let groups = getExerciseGroupStates(domain: domain, groupTitles: groupTitles)
        let restFAB = getRestFABViewState(isResting: domain.isResting, restPresets: domain.restPresets)
        
        let display = DoWorkoutDisplay(workoutName: domain.workout.name,
                                       progressBar: progressBar,
                                       groupTitles: groupTitles,
                                       groups: groups,
                                       restFAB: restFAB,
                                       expandedGroups: domain.expandedGroups,
                                       inCountdown: domain.inCountdown,
                                       isResting: domain.isResting,
                                       presentedDialog: dialog,
                                       finishDialog: finishDialog)

        return display
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
    
    func getRestFABViewState(isResting: Bool, restPresets: [Int]) -> RestFABViewState {
        return .init(isResting: isResting,
                     restPresets: restPresets)
    }
    
    func getSlider(isComplete: Bool) -> ActionSliderViewState? {
        var slider: ActionSliderViewState?
        
        if !isComplete {
            slider = ActionSliderViewState(sliderColor: .lightBlue,
                                           backgroundText: Strings.markAsComplete)
        }
        
        return slider
    }
    
    var finishDialog: DialogViewState {
        return DialogViewState(title: Strings.finishWorkout,
                               subtitle: Strings.changesSaved,
                               primaryButtonTitle: Strings.finish,
                               secondaryButtonTitle: Strings.cancel)
    }
}

fileprivate struct Strings {
    static let markAsComplete = "Mark as complete"
    static let finishWorkout = "Finish Workout?"
    static let changesSaved = "All of your changes will be saved."
    static let finish = "Finish"
    static let cancel = "Cancel"
}
