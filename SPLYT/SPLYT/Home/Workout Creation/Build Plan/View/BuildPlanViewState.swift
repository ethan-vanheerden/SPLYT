//
//  BuildPlanViewState.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 6/18/23.
//

import Foundation

enum BuildPlanViewState: Equatable {
    case error
    case loading
    case loaded(BuildPlanDisplay)
}
