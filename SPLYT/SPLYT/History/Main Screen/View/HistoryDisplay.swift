//
//  HistoryDisplay.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 7/16/23.
//

import Foundation
import DesignSystem

struct HistoryDisplay: Equatable {
    let workouts: [RoutineTileViewState]
    let presentedDialog: HistoryDialog?
    let deleteWorkoutHistoryDialog: DialogViewState
}
