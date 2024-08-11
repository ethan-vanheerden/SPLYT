//
//  HomeViewState.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 12/20/22.
//

import Foundation
import DesignSystem

enum HomeViewState: Equatable {
    case error
    case loading
    case main(HomeDisplay)
    case workoutInProgress
}
