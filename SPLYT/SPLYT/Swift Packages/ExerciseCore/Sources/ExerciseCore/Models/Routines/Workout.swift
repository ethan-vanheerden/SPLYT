//
//  Workout.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 8/13/22.
//

import Foundation

/// A workout. This same struct is used for workouts that are planned, in-progress, or completed.
public struct Workout: Codable, Equatable {
    public let id: String
    public let name: String
    public var exerciseGroups: [ExerciseGroup]
    public var planName: String? // The name of the owning plan
    public var createdAt: Date
    public var lastCompleted: Date?
    
    public init(id: String,
                name: String,
                exerciseGroups: [ExerciseGroup],
                planName: String? = nil,
                createdAt: Date,
                lastCompleted: Date? = nil) {
        self.id = id
        self.name = name
        self.exerciseGroups = exerciseGroups
        self.planName = planName
        self.createdAt = createdAt
        self.lastCompleted = lastCompleted
    }
}
