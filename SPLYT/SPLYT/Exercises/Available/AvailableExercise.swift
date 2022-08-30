//
//  AvailableExercise.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 8/30/22.
//

import Foundation

struct AvailableExercise: Codable, Equatable {
    let id: String
    let name: String
    let musclesWorked: [MusclesWorked]
}
