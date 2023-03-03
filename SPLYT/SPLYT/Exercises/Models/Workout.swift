//
//  Workout.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 8/13/22.
//

import Foundation

/// A created workout. This same struct is used for workouts that are planned, in-progress, or completed.
struct Workout: Codable, Equatable {
    let name: String
    let exerciseGroups: [ExerciseGroup]
    let lastCompleted: Date?
}
