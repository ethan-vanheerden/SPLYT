//
//  WorkoutsViewState.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 12/20/22.
//

import Foundation

enum WorkoutsViewState: Equatable {
    case loading
    case main(WorkoutsDisplayInfo)
}
