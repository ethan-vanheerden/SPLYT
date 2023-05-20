//
//  AvailableExercise.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 8/30/22.
//

import Foundation

/// Represents exercises that users can add when creating a workout.
public struct AvailableExercise: Codable, Equatable {
    public let id: String
    public let name: String
    public let musclesWorked: [MusclesWorked]
    public var isFavorite: Bool
    public let defaultInputType: SetInput
    public var isSelected = false

    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case musclesWorked = "muscles_worked"
        case isFavorite = "is_favorite"
        case defaultInputType = "default_input_type"
    }
}