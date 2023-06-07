//
//  DoWorkoutViewState.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 5/17/23.
//

import Foundation

enum DoWorkoutViewState: Equatable {
    case loading
    case error
    case loaded(DoWorkoutDisplay)
    case exit(DoWorkoutDisplay)
}
