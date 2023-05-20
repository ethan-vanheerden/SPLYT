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
    
    init(exercises: [String: AvailableExercise],
         builtWorkout: Workout,
         currentGroup: Int) {
        self.exercises = exercises
        self.builtWorkout = builtWorkout
        self.currentGroup = currentGroup
    }
    
    static func == (lhs: BuildWorkoutDomain, rhs: BuildWorkoutDomain) -> Bool {
        return lhs.exercises == rhs.exercises &&
        lhs.builtWorkout == rhs.builtWorkout &&
        lhs.currentGroup == rhs.currentGroup
    }
}

// MARK: - Dialog Type

enum BuildWorkoutDialog {
    case leave
    case save
}
