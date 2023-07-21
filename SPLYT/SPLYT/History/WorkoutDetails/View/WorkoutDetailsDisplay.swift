//
//  WorkoutDetailsDisplay.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 7/20/23.
//

import Foundation
import DesignSystem

struct WorkoutDetailsDisplay: Equatable {
    let workoutName: String
    let numExercisesTitle: String
    let completedTitle: String
    let groups: [CompletedExerciseGroupViewState]
    let expandedGroups: [Bool]
    let presentedDialog: WorkoutDetailsDialog?
    let deleteDialog: DialogViewState
}
