//
//  HomeDisplay.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 12/23/22.
//

import Foundation
import Core
import DesignSystem

struct HomeDisplay: Equatable {
    let navBar: NavigationBarViewState
    let segmentedControlTitles: [String] // ["WORKOUTS", "PLANS"]
    let workouts: [CreatedWorkoutViewState]
    let fab: FABViewState
}

/*
 
 struct BuildWorkoutDisplay: Equatable {
     let allExercises: [AddExerciseTileViewState] // Exercises that can be selected
     let groups: [[BuildExerciseViewState]] // Each item in list represents the exercises in the group
     let currentGroup: Int // Zero-indexed
     let currentGroupTitle: String
     let groupTitles: [String] // Ex: "Group 1", "Group 2", etc.
     let lastGroupEmpty: Bool
     let showDialog: BuildWorkoutDialog? // Determines which dialog is open, if any
     let backDialog: DialogViewState
     let saveDialog: DialogViewState
     let canSave: Bool
 }
 
 
 */
