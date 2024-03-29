//
//  HistoryDomain.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 7/16/23.
//

import Foundation
import ExerciseCore

// MARK: - Domain

struct HistoryDomain: Equatable {
    var workouts: [WorkoutHistory]
}

// MARK: - Dialog Type

enum HistoryDialog: Equatable {
    case deleteWorkoutHistory(historyId: String)
}
