//
//  NameWorkoutDomain.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 6/16/23.
//

import Foundation

struct NameWorkoutDomain: Equatable {
    var workoutName: String
    let buildType: NameWorkoutBuildType
}

// MARK: - Build Type

enum NameWorkoutBuildType {
    case workout
    case plan
}
