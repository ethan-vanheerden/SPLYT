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
    let workouts: [CreatedWorkoutViewState]
    let fab: HomeFABViewState
    let showDialog: HomeDialog?
    let deleteDialog: DialogViewState
}
