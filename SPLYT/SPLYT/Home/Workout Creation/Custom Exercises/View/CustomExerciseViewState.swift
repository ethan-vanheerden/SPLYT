//
//  CustomExerciseViewState.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 5/22/24.
//

import Foundation

enum CustomExerciseViewState: Equatable {
    case loading
    case error
    case loaded(CustomExerciseDisplay)
    case exit(CustomExerciseDisplay)
}
