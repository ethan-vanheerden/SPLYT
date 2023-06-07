//
//  CreatedWorkoutsCacheRequest.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 2/28/23.
//

import Caching
import ExerciseCore

struct CreatedWorkoutsCacheRequest: CacheRequest {
    typealias CacheData = [CreatedWorkout]
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


/*
 1. File for [ID: CreatedWorkout] for all workouts created
 2. File for [Workout] for all the times that workout has been done
 
 File will use 1 to show all required info
 
 Actual workout will use the specific workout file
 
 Do we have an additional file for all workouts completed? (limit this to a specific amount at least on the cachine side?)
 
 
 1. File for [ID: Workout] for all workouts created
 2. File for [Workout] for a certain workout's history
 
 */
