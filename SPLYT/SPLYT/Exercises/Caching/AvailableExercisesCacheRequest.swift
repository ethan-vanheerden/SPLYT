//
//  AvailableExercisesCacheRequest.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 12/14/22.
//

import Foundation
import Caching

struct AvailableExercisesCacheRequest: CacheRequest {
    typealias CacheData = [AvailableExercise]
    
    var filename: String = "available_exercises"
}
