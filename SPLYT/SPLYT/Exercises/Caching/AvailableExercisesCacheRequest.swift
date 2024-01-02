//
//  AvailableExercisesCacheRequest.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 12/14/22.
//

import Caching
import ExerciseCore

struct AvailableExercisesCacheRequest: CacheRequest {
    typealias CacheData = [String: AvailableExercise]
    let filename: String = "available_exercises"
}
