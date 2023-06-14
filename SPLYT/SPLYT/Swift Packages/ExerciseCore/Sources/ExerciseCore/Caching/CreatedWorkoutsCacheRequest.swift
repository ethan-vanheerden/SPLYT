//
//  CreatedWorkoutsCacheRequest.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 2/28/23.
//

import Caching

struct CreatedWorkoutsCacheRequest: CacheRequest {
    // Dictionary of the workout ID to its associated object
    typealias CacheData = [String: CreatedWorkout]
    let filename: String = "user_created_workouts"
}
