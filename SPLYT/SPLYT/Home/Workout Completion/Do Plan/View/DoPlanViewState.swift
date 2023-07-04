//
//  DoPlanViewState.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 7/4/23.
//

import Foundation

enum DoPlanViewState: Equatable {
    case loading
    case error
    case loaded(DoPlanDisplay)
}
