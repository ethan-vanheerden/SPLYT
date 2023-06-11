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
    var expandedGroups: [Bool] // Indicates which group's headers are expanded (true = expanded)
    var completedGroups: [Bool] // Indicates which groups have been marked as complete
    var fractionCompleted: Double // Ex: 0.5 for 50% done
    
    init(workout: Workout,
         inCountdown: Bool,
         isResting: Bool,
         expandedGroups: [Bool],
         completedGroups: [Bool],
         fractionCompleted: Double) {
        self.workout = workout
        self.inCountdown = inCountdown
        self.isResting = isResting
        self.expandedGroups = expandedGroups
        self.completedGroups = completedGroups
        self.fractionCompleted = fractionCompleted
    }
    
    static func == (lhs: DoWorkoutDomain, rhs: DoWorkoutDomain) -> Bool {
        return lhs.workout == rhs.workout &&
        lhs.inCountdown == rhs.inCountdown &&
        lhs.isResting == rhs.isResting &&
        lhs.expandedGroups == rhs.expandedGroups &&
        lhs.completedGroups == rhs.completedGroups &&
        lhs.fractionCompleted == rhs.fractionCompleted
    }
}

// MARK: - Dialog Type

enum DoWorkoutDialog: Equatable {
    case finishWorkout
}
