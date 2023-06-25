//
//  HomeDomain.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 2/28/23.
//

import Foundation
import ExerciseCore

// MARK: - Domain

struct HomeDomain: Equatable {
    var workouts: [String: CreatedWorkout]
}

// MARK: - Dialog Type

enum HomeDialog: Equatable {
    case deleteWorkout(id: String, filename: String?)
}
