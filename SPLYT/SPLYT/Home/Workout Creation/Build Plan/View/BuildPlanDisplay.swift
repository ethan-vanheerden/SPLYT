//
//  BuildPlanDisplay.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 6/18/23.
//

import Foundation
import DesignSystem

struct BuildPlanDisplay: Equatable {
    let workouts: [WorkoutTileViewState]
    let canSave: Bool
    let presentedDialog: BuildPlanDialog?
    let backDialog: DialogViewState
    let saveDialog: DialogViewState
    let deleteDialog: DialogViewState
}
