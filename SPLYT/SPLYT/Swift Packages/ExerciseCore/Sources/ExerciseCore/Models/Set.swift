//
//  Set.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 8/11/22.
//

import Foundation

/// An exercise's set.
public struct Set: Codable, Equatable {
    public let input: SetInput
    public var modifier: SetModifier?
    
    public init(input: SetInput,
                modifier: SetModifier?) {
        self.input = input
        self.modifier = modifier
    }
    
    private enum CodingKeys: String, CodingKey {
        case input = "input_type"
        case modifier
    }
}
