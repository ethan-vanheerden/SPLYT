//
//  WorkoutDetailsViewState.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 7/20/23.
//

import Foundation

enum WorkoutDetailsViewState: Equatable {
    case loading
    case error
    case loaded(WorkoutDetailsDisplay)
}
