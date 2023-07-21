//
//  WorkoutDetailsDomain.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 7/20/23.
//

import Foundation
import ExerciseCore

struct WorkoutDetailsDomain: Equatable {
    // TODO: do we want to load the last workout so we can do comparisons?
    var workout: Workout
    var expandedGroups: [Bool]
}

// MARK: Dialog

enum WorkoutDetailsDialog: Equatable {
    case delete
}
