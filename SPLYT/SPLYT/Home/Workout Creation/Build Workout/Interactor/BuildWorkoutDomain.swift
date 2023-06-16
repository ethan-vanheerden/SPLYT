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
    
    init(exercises: [String: AvailableExercise],
         builtWorkout: Workout,
         currentGroup: Int,
         filterDomain: BuildWorkoutFilterDomain) {
        self.exercises = exercises
        self.builtWorkout = builtWorkout
        self.currentGroup = currentGroup
        self.filterDomain = filterDomain
    }
    
    static func == (lhs: BuildWorkoutDomain, rhs: BuildWorkoutDomain) -> Bool {
        return lhs.exercises == rhs.exercises &&
        lhs.builtWorkout == rhs.builtWorkout &&
        lhs.currentGroup == rhs.currentGroup &&
        lhs.currentGroup == rhs.currentGroup
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

// MARK: - Enums

enum BuildWorkoutFilter {
    case search(searchText: String)
    case favorite(isFavorite: Bool)
    case muscleWorked(muscle: MusclesWorked, isSelected: Bool)
}
