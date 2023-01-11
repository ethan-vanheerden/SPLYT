//
//  BuildWorkoutViewState.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 1/11/23.
//

import Foundation

enum BuildWorkoutViewState: Equatable {
    case loading
    case main(BuildWorkoutDisplay)
    case error
}
