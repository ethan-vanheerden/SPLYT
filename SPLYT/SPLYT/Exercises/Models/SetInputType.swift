//
//  SetInputType.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 8/12/22.
//

import Foundation

/// The data that is used to record a weightlifting set. All of the associated values are optional in case the set is skipped.
enum SetInputType: Codable, Equatable {
    case repsWeight(reps: Int?, weight: Double?)
    case repsOnly(reps: Int?)
    case time(seconds: Int?)
    
    private enum CodingKeys: String, CodingKey {
        case repsWeight = "REPS_WEIGHT"
        case repsOnly = "REPS_ONLY"
        case time = "TIME"
    }
}
