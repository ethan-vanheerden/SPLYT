//
//  BuildWorkoutDisplay.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 1/21/23.
//

import Foundation
import DesignSystem
import ExerciseCore

struct BuildWorkoutDisplay: Equatable {
    let allExercises: [AddExerciseTileSectionViewState] // Exercises that can be selected
    let groups: [[ExerciseViewState]] // Each item in list represents the exercises in the group
    let currentGroup: Int // Zero-indexed
    let currentGroupTitle: String
    let groupTitles: [String] // Ex: "Group 1", "Group 2", etc.
    let lastGroupEmpty: Bool
    let showDialog: BuildWorkoutDialog? // Determines which dialog is open, if any
    let backDialog: DialogViewState
    let saveDialog: DialogViewState
    let canSave: Bool
    let filterDisplay: BuildWorkoutFilterDisplay
    let isFiltering: Bool
}


// MARK: - Filter Display

struct BuildWorkoutFilterDisplay: Equatable {
    let isFavorite: Bool
    let musclesWorked: [MusclesWorked: Bool]
}

// MARK: - View State

struct AddExerciseTileSectionViewState: Equatable, Hashable {
    let header: SectionHeaderViewState
    let exercises: [AddExerciseTileViewState]
    
    init(header: SectionHeaderViewState,
         exercises: [AddExerciseTileViewState]) {
        self.header = header
        self.exercises = exercises
    }
}

/*
 - When viewing the list of exercises, we only select the exercises we want in each group
 - x Instead of just a checkmark, there will be a number next to that exercise for the group it is selected in
    - x Multiple numbers allowed if the exercise is in multiple groups
 - Still show the number of exercises in the current group, and a button to add a new group
 - x Can only add a group if the previous one is not empty
 - x *Only remove a group if there are no exercises in it and it is not the currently selected group
 - Then clicking on next will let you edit the sets + reps of all exercises
    - Navigation link of a new view with a reference to the same view model (I think I've done this somewhere before)
 
 */
