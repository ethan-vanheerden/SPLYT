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
    public var isFavorite: Bool = false
    public let defaultInputType: SetInput
    public var selectedGroups: [Int] = [] // The groups in the workout which have this exercise
    
    public init(id: String,
                name: String,
                musclesWorked: [MusclesWorked],
                isFavorite: Bool = false,
                defaultInputType: SetInput,
                selectedGroups: [Int] = []) {
        self.id = id
        self.name = name
        self.musclesWorked = musclesWorked
        self.isFavorite = isFavorite
        self.defaultInputType = defaultInputType
        self.selectedGroups = selectedGroups
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.musclesWorked = try container.decode([MusclesWorked].self, forKey: .musclesWorked)
        self.defaultInputType = try container.decode(SetInput.self, forKey: .defaultInputType)
        
        // Cache request has the is_favorite field, the network request doesn't
        self.isFavorite = try container.decodeIfPresent(Bool.self, forKey: .isFavorite) ?? false
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case musclesWorked = "muscles_worked"
        case isFavorite = "is_favorite"
        case defaultInputType = "default_input_type"
    }
}
