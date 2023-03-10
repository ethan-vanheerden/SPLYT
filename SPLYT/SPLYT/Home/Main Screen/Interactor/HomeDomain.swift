//
//  HomeDomain.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 2/28/23.
//

import Foundation

// MARK: - Domain

struct HomeDomain: Equatable {
    var workouts: [Workout]
}

// MARK: - Dialog Type

enum HomeDialog: Equatable {
    case deleteWorkout(id: String)
}
