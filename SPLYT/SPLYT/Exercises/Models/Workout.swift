//
//  Workout.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 8/13/22.
//

import Foundation

/// A created workout. This same struct is used for workouts that are planned, in-progress, or completed.
final class Workout: Codable, Equatable {
    let id: String
    var name: String
    var exerciseGroups: [ExerciseGroup]
    var lastCompleted: Date?
    
    init(id: String,
         name: String,
         exerciseGroups: [ExerciseGroup],
         lastCompleted: Date? = nil) {
        self.id = id
        self.name = name
        self.exerciseGroups = exerciseGroups
        self.lastCompleted = lastCompleted
    }
    
    static func == (lhs: Workout, rhs: Workout) -> Bool {
        return lhs.id == rhs.id &&
        lhs.name == rhs.name &&
        lhs.exerciseGroups == rhs.exerciseGroups &&
        lhs.lastCompleted == rhs.lastCompleted
    }
}
