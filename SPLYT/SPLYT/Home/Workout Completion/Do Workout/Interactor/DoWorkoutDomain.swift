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
    var inCountdown: Bool
    var isResting: Bool
    
    init(workout: Workout,
         inCountdown: Bool,
         isResting: Bool) {
        self.workout = workout
        self.inCountdown = inCountdown
        self.isResting = isResting
    }
    
    static func == (lhs: DoWorkoutDomain, rhs: DoWorkoutDomain) -> Bool {
        return true // TODO
    }
}
