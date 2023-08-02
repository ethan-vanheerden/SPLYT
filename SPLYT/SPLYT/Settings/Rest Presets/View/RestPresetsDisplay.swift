//
//  RestPresetsDisplay.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 8/1/23.
//

import Foundation

struct RestPresetsDisplay: Equatable {
    let presets: [PresetDisplay]
}

// MARK: - Other Displays

struct PresetDisplay: Hashable {
    let index: Int
    let title: String
    let preset: Int // The total number of seconds in the preset
    let minutes: Int // The totoal number of minutes in the preset
    let seconds: Int // The total number of seconds left over outside of the minutes
}
