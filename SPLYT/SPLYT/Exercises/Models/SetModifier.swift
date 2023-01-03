//
//  SetModifier.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 8/12/22.
//

import Foundation

/// Different modifiers that affect a set's behavior.
enum SetModifier: String, Codable, Equatable {
    case dropSet = "DROP_SET"
    case restPause = "REST_PAUSE"
    case eccentric = "ECCENTRIC"
}
