//
//  NameWorkoutViewState.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 6/16/23.
//

import Foundation

enum NameWorkoutViewState: Equatable {
    case error
    case loading
    case loaded(NameWorkoutDisplay)
}
