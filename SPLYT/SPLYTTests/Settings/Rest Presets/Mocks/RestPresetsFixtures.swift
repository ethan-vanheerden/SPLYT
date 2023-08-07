//
//  RestPresetsFixtures.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 8/3/23.
//

import Foundation
@testable import SPLYT

struct RestPresetsFixtures {
    // MARK: - Domain
    
    static let presets: [Int] = [60, 90, 120]
    
    // MARK: - View States
    
    static let presetDisplay_60: PresetDisplay = .init(index: 0,
                                                       title: "01:00",
                                                       preset: 60,
                                                       minutes: 1,
                                                       seconds: 0)
    
    static let presetDisplay_90: PresetDisplay = .init(index: 1,
                                                       title: "01:30",
                                                       preset: 90,
                                                       minutes: 1,
                                                       seconds: 30)
    
    static let presetDisplay_120: PresetDisplay = .init(index: 2,
                                                       title: "02:00",
                                                       preset: 120,
                                                       minutes: 2,
                                                       seconds: 0)
    
    static let presetDisplays: [PresetDisplay] = [
        presetDisplay_60,
        presetDisplay_90,
        presetDisplay_120
    ]
    
    static let footerMessage: String = """
These are your quick-access rest shortcuts you can select while you are doing your workout.
"""
}
