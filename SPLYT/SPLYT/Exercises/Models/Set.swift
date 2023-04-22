//
//  Set.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 8/11/22.
//

import Foundation
import ExerciseCore

/// An exercise's set.
struct Set: Codable, Equatable {
    let input: SetInput
    var modifier: SetModifier?
    
    private enum CodingKeys: String, CodingKey {
        case input = "input_type"
        case modifier
    }
}
