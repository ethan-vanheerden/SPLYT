//
//  Exercise.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 8/11/22.
//

import Foundation

struct Exercise: Codable, Equatable {
    let id: String
    let name: String
    let sets: [Set]
}



/*
 Workout -> List of Groups
 Groups -> has a list of exercises
    - Number of exercises determines of it is a superset or not
 Exercises -> Has a list of sets, list of notes
 Sets -> Has a type (reps/weight, reps only, time, etc.) and a set modifier (dropset, restpause)
 TODO: Add Exercise/Set Notes
 */
