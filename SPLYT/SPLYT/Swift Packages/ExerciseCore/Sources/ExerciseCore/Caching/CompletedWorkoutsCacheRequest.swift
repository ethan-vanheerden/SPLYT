//
//  CompletedWorkoutsCacheRequest.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 7/16/23.
//

import Foundation
import Caching

/// Stores all the workout instances the user has completed in a long list (most recent first).
public struct CompletedWorkoutsCacheRequest: CacheRequest {
    public typealias CacheData = [WorkoutHistory]
    public let filename = "all_completed_workouts"
    
    public init() { }
}
