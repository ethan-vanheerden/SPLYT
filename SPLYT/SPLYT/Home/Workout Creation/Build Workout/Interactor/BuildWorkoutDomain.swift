//
//  BuildWorkoutDomainObject.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 1/11/23.
//

import Foundation
import ExerciseCore

// MARK: - Domain

final class BuildWorkoutDomain: Equatable {
    var exercises: [String: AvailableExercise] // Map of the exercise ID to the exercise
    var builtWorkout: Workout
    var currentGroup: Int // Zero-indexed
    var filterDomain: BuildWorkoutFilterDomain
    var canSave: Bool
    
    init(exercises: [String: AvailableExercise],
         builtWorkout: Workout,
         currentGroup: Int,
         filterDomain: BuildWorkoutFilterDomain,
         canSave: Bool) {
        self.exercises = exercises
        self.builtWorkout = builtWorkout
        self.currentGroup = currentGroup
        self.filterDomain = filterDomain
        self.canSave = canSave
    }
    
    static func == (lhs: BuildWorkoutDomain, rhs: BuildWorkoutDomain) -> Bool {
        return lhs.exercises == rhs.exercises &&
        lhs.builtWorkout == rhs.builtWorkout &&
        lhs.currentGroup == rhs.currentGroup &&
        lhs.filterDomain == rhs.filterDomain &&
        lhs.canSave == rhs.canSave
    }
}

// MARK: - Dialog Type

enum BuildWorkoutDialog {
    case leave
    case save
}

// MARK: - Filter Domain

struct BuildWorkoutFilterDomain: Equatable {
    var searchText: String
    var isFavorite: Bool
    var musclesWorked: [MusclesWorked: Bool] // Dictionary of each muscle worked to whether it is being filtered
}

// MARK: - Filters

enum BuildWorkoutFilter {
    case search(searchText: String)
    case favorite(isFavorite: Bool)
    case muscleWorked(muscle: MusclesWorked, isSelected: Bool)
}
