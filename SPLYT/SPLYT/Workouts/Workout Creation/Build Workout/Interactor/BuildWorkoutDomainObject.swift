//
//  BuildWorkoutDomainObject.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 1/11/23.
//

import Foundation

struct BuildWorkoutDomainObject: Equatable {
    let exercises: [AvailableExercise]
    let builtWorkout: Workout
    let currentGroup: Int // Zero-indexed
}
