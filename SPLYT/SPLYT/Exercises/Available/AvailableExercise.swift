//
//  AvailableExercise.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 8/30/22.
//

import Foundation

/// Represents exercises that users can add when creating a workout.
struct AvailableExercise: Codable, Equatable {
    let id: String
    let name: String
    let musclesWorked: [MusclesWorked]
}
