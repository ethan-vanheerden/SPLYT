//
//  NameWorkoutDisplay.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 6/16/23.
//

import Foundation
import DesignSystem

struct NameWorkoutDisplay: Equatable {
    let navBar: NavigationBarViewState
    let workoutName: String
    let textEntry: TextEntryViewState
    let buildType: NameWorkoutBuildType
    let nextButtonEnabled: Bool
}
