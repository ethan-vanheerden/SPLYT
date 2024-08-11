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
    let groups: [[ExerciseViewStatus]] // Each item in list represents the exercises in the group
    let currentGroup: Int // Zero-indexed
    let groupTitles: [String] // Ex: "Group 1", "Group 2", etc.
    let lastGroupEmpty: Bool
    let shownDialog: BuildWorkoutDialog? // Determines which dialog is open, if any
    let backDialog: DialogViewState
    let saveDialog: DialogViewState
    let canSave: Bool
    let filterDisplay: BuildWorkoutFilterDisplay
    let isFiltering: Bool
    let supersetDisplay: SupersetDisplay
}


// MARK: - Filter Display

struct BuildWorkoutFilterDisplay: Equatable {
    let isFavorite: Bool
    let musclesWorked: [MusclesWorked: Bool]
}

// MARK: - Superset Display

struct SupersetDisplay: Equatable {
    let isCreatingSuperset: Bool
    let currentSupersetTitle: String
    let canSave: Bool
    let exerciseIds: [String] // The ids of the exercises in the current editing superset
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
