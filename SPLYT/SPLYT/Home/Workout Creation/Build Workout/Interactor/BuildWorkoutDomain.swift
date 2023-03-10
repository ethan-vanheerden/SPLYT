//
//  BuildWorkoutDomainObject.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 1/11/23.
//

import Foundation

// MARK: - Domain

struct BuildWorkoutDomain: Equatable {
    let exercises: [AvailableExercise]
    let builtWorkout: Workout
    let currentGroup: Int // Zero-indexed
}

// MARK: - Dialog Type

enum BuildWorkoutDialog {
    case leave
    case save
}
