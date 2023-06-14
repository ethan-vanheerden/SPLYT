//
//  Exercise.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 8/11/22.
//

import Foundation

/// Represents an exercise and the series of sets performed in it.
/// Note: This is different from `AvailableExercise` in the sense that an `AvailableExercise`
///      is just a barebones representation of an exercise with no utility. An `Exercise` is the user-completed
///      version of an `AvailableExercise`.
public struct Exercise: Codable, Equatable {
    public let id: String
    public let name: String
    public var sets: [Set]
    
    public init(id: String,
                name: String,
                sets: [Set]) {
        self.id = id
        self.name = name
        self.sets = sets
    }
}
