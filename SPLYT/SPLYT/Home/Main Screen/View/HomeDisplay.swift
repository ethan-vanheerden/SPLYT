//
//  HomeDisplay.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 12/23/22.
//

import Foundation
import Core
import DesignSystem

struct HomeDisplay: Equatable {
    let navBar: NavigationBarViewState
    let segmentedControlTitles: [String] // ["WORKOUTS", "PLANS"]
    let workouts: [RoutineTileViewState]
    let plans: [RoutineTileViewState]
    let fab: HomeFABViewState
    let presentedDialog: HomeDialog?
    let deleteWorkoutDialog: DialogViewState
    let deletePlanDialog: DialogViewState
}
