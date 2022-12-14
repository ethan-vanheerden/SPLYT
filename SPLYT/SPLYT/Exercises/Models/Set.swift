//
//  Set.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 8/11/22.
//

import Foundation

/// An exercise's set.
struct Set: Codable, Equatable {
    let inputType: SetInputType
    let modifier: SetModifier
    
    private enum CodingKeys: String, CodingKey {
        case inputType = "input_type"
        case modifier
    }
}
