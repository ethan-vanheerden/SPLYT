//
//  CustomExerciseDomain.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 5/22/24.
//

import Foundation
import ExerciseCore

struct CustomExerciseDomain: Equatable {
    var exerciseName: String
    var musclesWorked: [MusclesWorked: Bool]
    var canSave: Bool
    var isSaving: Bool
}

// MARK: - Dialog Type

enum CustomExerciseDialog: Equatable {
    case exerciseAlreadyExists
}
