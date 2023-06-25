//
//  NameWorkoutDomain.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 6/16/23.
//

import Foundation

struct NameWorkoutDomain: Equatable {
    var workoutName: String
    let buildType: BuildWorkoutType
}

// MARK: - Build Type

enum BuildWorkoutType {
    case workout
    case plan
}
