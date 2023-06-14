//
//  WorkoutHistoryCacheRequest.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 6/6/23.
//

import Caching
import ExerciseCore

struct WorkoutHistoryCacheRequest: CacheRequest {
    // Contains a list of workouts in decreasing order of completed at date (Most recent first).
    typealias CacheData = [Workout]
    let filename: String
    
    init(filename: String) {
        self.filename = filename
    }
}
