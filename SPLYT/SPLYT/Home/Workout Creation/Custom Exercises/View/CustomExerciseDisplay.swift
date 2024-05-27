//
//  CustomExerciseDisplay.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 5/22/24.
//

import Foundation
import ExerciseCore
import DesignSystem

struct CustomExerciseDisplay: Equatable {
    let exerciseName: String
    let musclesWorked: [MusclesWorked: Bool]
    let exerciseNameEntry: TextEntryViewState
    let musclesWorkedHeader: SectionHeaderViewState
    let canSave: Bool
}
