//
//  DoWorkoutDomain.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 5/17/23.
//

import Foundation
import ExerciseCore

struct DoWorkoutDomain: Equatable {
    var workout: Workout
    var inCountdown: Bool
    var isResting: Bool
    var expandedGroups: [Bool] // Indicates which group's headers are expanded (true = expanded)
    var completedGroups: [Bool] // Indicates which groups have been marked as complete
    var fractionCompleted: Double // Ex: 0.5 for 50% done
    let restPresets: [Int]
    var workoutDetailsId: String?
    var cachedSecondsElapsed: Int? // Used the first time an cached in progress workout is loaded
    var canDeleteExercise: Bool
}

// MARK: - Dialog Type

enum DoWorkoutDialog: Equatable {
    case finishWorkout
}
