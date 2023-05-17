//
//  CreatedWorkoutsCacheRequest.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 2/28/23.
//

import Caching

struct CreatedWorkoutsCacheRequest: CacheRequest {
    typealias CacheData = [String: Workout] // Dictionary of the workout ID to the actual workout
    let filename: String = "user_created_workouts"
}
