//
//  DoWorkoutFixtures.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 6/12/23.
//

import Foundation
@testable import DesignSystem

struct DoWorkoutFixtures {
    typealias StateFixtures = WorkoutViewStateFixtures
    // MARK: - View States
    
    static let markAsComplete = "Mark as complete"
    
    static func progressBar(fractionCompleted: Double) -> ProgressBarViewState {
        return ProgressBarViewState(fractionCompleted: fractionCompleted,
                                    color: .lightBlue,
                                    outlineColor: .lightBlue)
    }
    
    static func groupOneHeader(isComplete: Bool) -> CollapseHeaderViewState {
        return CollapseHeaderViewState(title: "Group 1",
                                       color: .lightBlue,
                                       isComplete: isComplete)
    }
    
    static func groupTwoHeader(isComplete: Bool) -> CollapseHeaderViewState {
        return CollapseHeaderViewState(title: "Group 2",
                                       color: .lightBlue,
                                       isComplete: isComplete)
    }
    
    static let actionSlider: ActionSliderViewState = .init(sliderColor: .lightBlue,
                                                           backgroundText: markAsComplete)
    
    static let finishDialog: DialogViewState = .init(title: "Finish Workout",
                                                     subtitle: "All of your changes will be saved.",
                                                     primaryButtonTitle: "Finish",
                                                     secondaryButtonTitle: "Cancel")
    
    static var legWorkoutStartingGroups: [DoExerciseGroupViewState] {
        let groupsExercises = StateFixtures.legWorkoutExercisesPlaceholders(includeHeaderLine: false)
        
        return [
            DoExerciseGroupViewState(header: groupOneHeader(isComplete: false),
                                     exercises: groupsExercises[0],
                                     slider: actionSlider),
            DoExerciseGroupViewState(header: groupTwoHeader(isComplete: false),
                                     exercises: groupsExercises[1],
                                     slider: actionSlider),
        ]
    }
}
