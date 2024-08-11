//
//  InProgressWorkoutCacheRequest.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 5/19/24.
//

import Foundation
import Caching
import ExerciseCore

// Stores a copy of the user's in progress workout in case of crash mid-workout
struct InProgressWorkoutCacheRequest: CacheRequest {
    typealias CacheData = InProgressWorkout
    let filename: String = "in_progress_workout"
}

struct InProgressWorkout: Codable {
    let secondsElapsed: Int
    let workout: Workout
    let planId: String?
    let expandedGroups: [Bool]
    let completedGroups: [Bool]
    let fractionCompleted: Double
}
