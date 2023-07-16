//
//  WorkoutHistoryCacheRequest.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 6/6/23.
//

import Caching
import ExerciseCore

/// Stores all the histories for a specifc Workout (most recent first).
struct WorkoutHistoryCacheRequest: CacheRequest {
    typealias CacheData = [Workout]
    let filename: String
    
    init(filename: String) {
        self.filename = filename
    }
}
