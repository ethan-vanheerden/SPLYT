//
//  DoWorkoutDomain.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 5/17/23.
//

import Foundation
import ExerciseCore

final class DoWorkoutDomain: Equatable {
    var workout: Workout
    
    init(workout: Workout) {
        self.workout = workout
    }
    
    static func == (lhs: DoWorkoutDomain, rhs: DoWorkoutDomain) -> Bool {
        return true // TODO
    }
}
