//
//  BuildWorkoutDisplay.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 1/21/23.
//

import Foundation
import DesignSystem

struct BuildWorkoutDisplay: Equatable {
    let allExercises: [AddExerciseTileViewState] // Exercises that can be selected
    let groups: [[BuildExerciseViewState]] // Each item in list represents the exercises in the group
    let currentGroup: Int // Zero-indexed
    let currentGroupTitle: String
    let groupTitles: [String] // Ex: "Group 1", "Group 2", etc.
    let lastGroupEmpty: Bool
}
