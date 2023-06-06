//
//  CreatedWorkoutsCacheRequest.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 2/28/23.
//

import Caching
import ExerciseCore

struct CreatedWorkoutsCacheRequest: CacheRequest {
    /* Dictionary of the workout ID to the actual workout. The associated workout will be
       the most recent version of the workout completed that the user would like saved. */
    typealias CacheData = [String: Workout]
    let filename: String = "user_created_workouts"
    
    /*
     Options:
     Keep this as it was and have and don't worry about any progress after the first one. - How do we get workout history?
     Pros: Easiest
     Cons: Can't see progress other than the last workout, will have one huge file here and if it goes away so does everything
     
     Have this file be a map for the workout ID to the filename of the workout.
     This file will contain a list of workouts, in increasing order of completion date
     
     Pros: More history data for showing to the user, we don't have to edit a mega file every time so loading and saving will be faster
     Cons: This could take up a lot of space
     */
}
