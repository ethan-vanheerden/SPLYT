//
//  CompletedWorkoutsCacheRequest.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 7/16/23.
//

import Foundation
import Caching
import ExerciseCore

/// Stores all the workout instances the user has completed in a long list (most recent first).
struct CompletedWorkoutsCacheRequest: CacheRequest {
    typealias CacheData = [WorkoutHistory]
    let filename = "all_completed_workouts"
}
