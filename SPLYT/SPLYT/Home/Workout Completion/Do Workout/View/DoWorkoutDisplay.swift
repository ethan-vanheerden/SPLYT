//
//  DoWorkoutDisplay.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 5/18/23.
//

import Foundation
import DesignSystem

// Both the exercise preview and the do view will use this
struct DoWorkoutDisplay: Equatable {
    let workoutName: String
    let groups: [[ExerciseViewState]]
    let groupTitles: [String]
}
