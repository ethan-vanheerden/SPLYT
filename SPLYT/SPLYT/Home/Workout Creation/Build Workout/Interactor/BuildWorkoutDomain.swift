//
//  BuildWorkoutDomainObject.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 1/11/23.
//

import ExerciseCore
import Foundation

// MARK: - Domain

final class BuildWorkoutDomain: Equatable {
    var exercises: [String: AvailableExercise]  // Map of the exercise ID to the exercise
    var builtWorkout: Workout
    var currentGroup: Int  // Zero-indexed
    var filterDomain: BuildWorkoutFilterDomain
    var canSave: Bool
    var isCreatingSuperset: Bool
    var canSaveSuperset: Bool
    var supersetExerciseIds: [String]
    
    init(exercises: [String: AvailableExercise],
         builtWorkout: Workout,
         currentGroup: Int,
         filterDomain: BuildWorkoutFilterDomain,
         canSave: Bool,
         isCreatingSuperset: Bool,
         canSaveSuperset: Bool,
         supersetExerciseIds: [String]) {
        self.exercises = exercises
        self.builtWorkout = builtWorkout
        self.currentGroup = currentGroup
        self.filterDomain = filterDomain
        self.canSave = canSave
        self.isCreatingSuperset = isCreatingSuperset
        self.canSaveSuperset = canSaveSuperset
        self.supersetExerciseIds = supersetExerciseIds
    }
    
    static func == (lhs: BuildWorkoutDomain, rhs: BuildWorkoutDomain) -> Bool {
        return lhs.exercises == rhs.exercises && 
        lhs.builtWorkout == rhs.builtWorkout &&
        lhs.currentGroup == rhs.currentGroup &&
        lhs.filterDomain == rhs.filterDomain &&
        lhs.canSave == rhs.canSave &&
        lhs.isCreatingSuperset == rhs.isCreatingSuperset &&
        lhs.canSaveSuperset == rhs.canSaveSuperset &&
        lhs.supersetExerciseIds == rhs.supersetExerciseIds
    }
}

// MARK: - Dialog Type

enum BuildWorkoutDialog: Equatable {
    case leave
    case save
}

// MARK: - Filter Domain

struct BuildWorkoutFilterDomain: Equatable {
    var searchText: String
    var isFavorite: Bool
    var musclesWorked: [MusclesWorked: Bool]  // Dictionary of each muscle worked to whether it is being filtered
}

// MARK: - Filters

enum BuildWorkoutFilter {
    case search(searchText: String)
    case favorite(isFavorite: Bool)
    case muscleWorked(muscle: MusclesWorked, isSelected: Bool)
}
