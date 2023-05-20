//
//  ExerciseGroup.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 8/13/22.
//

import Foundation

/// A series of exercises that are performed at a time in a workout.
public struct ExerciseGroup: Codable, Equatable {
    public let exercises: [Exercise]
    
    public init(exercises: [Exercise]) {
        self.exercises = exercises
    }
}
