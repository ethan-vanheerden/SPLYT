//
//  MusclesWorked.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 8/30/22.
//

import Foundation

/// Muscles worked in an exercise.
public enum MusclesWorked: String, Codable, CaseIterable {
    case chest = "CHEST"
    case shoulders = "SHOULDERS"
    case back = "BACK"
    case quads = "QUADS"
    case calves = "CALVES"
    case triceps = "TRICEPS"
    case biceps = "BICEPS"
    case core = "CORE"
    case hamstrings = "HAMSTRINGS"
    case glutes = "GLUTES"
    case power = "POWER"
    case other = "OTHER"
}
