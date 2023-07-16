//
//  DoPlanDisplay.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 7/4/23.
//

import Foundation
import DesignSystem

struct DoPlanDisplay: Equatable {
    let navBar: NavigationBarViewState
    let workouts: [RoutineTileViewState]
}
