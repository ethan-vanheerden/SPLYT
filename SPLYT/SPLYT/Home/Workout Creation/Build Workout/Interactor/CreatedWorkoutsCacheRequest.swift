//
//  CreatedWorkoutsCacheRequest.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 2/28/23.
//

import Caching

struct CreatedWorkoutsCacheRequest: CacheRequest {
    typealias CacheData = [Workout]
    let filename: String = "user_created_workouts"
}
