//
//  AvailableExercise.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 8/30/22.
//

import Foundation

/// Represents exercises that users can add when creating a workout.
struct AvailableExercise: Codable, Equatable {
    let id: String
    let name: String
    let musclesWorked: [MusclesWorked]
    let isFavorite: Bool
    let defaultInputType: SetInputType
    var isSelected = false

    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case musclesWorked = "muscles_worked"
        case isFavorite = "is_favorite"
        case defaultInputType = "default_input_type"
    }
}
