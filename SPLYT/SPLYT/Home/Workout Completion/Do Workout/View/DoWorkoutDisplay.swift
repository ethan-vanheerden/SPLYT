//
//  DoWorkoutDisplay.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 5/18/23.
//

import Foundation
import DesignSystem

// Both the exercise preview and the do view will use this
struct DoWorkoutDisplay: Equatable {
    let workoutName: String
    let progressBar: ProgressBarViewState
    let groupTitles: [String]
    let groups: [DoExerciseGroupViewState]
    let restFAB: RestFABViewState
    let expandedGroups: [Bool]
    let inCountdown: Bool
    let isResting: Bool
    let presentedDialog: DoWorkoutDialog?
    let finishDialog: DialogViewState
    let workoutDetailsId: String?
}
