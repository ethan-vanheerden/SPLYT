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
struct Exercise: Codable, Equatable {
    let id: String
    let name: String
    let sets: [Set]
}
