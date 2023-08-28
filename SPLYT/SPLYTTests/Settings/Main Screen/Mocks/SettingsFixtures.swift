//
//  SettingsFixtures.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 8/2/23.
//

import Foundation
@testable import SPLYT

struct SettingsFixtures {
    
    // MARK: Domain
    
    static let workoutSection: SettingsSection = .init(title: "WORKOUT",
                                                       items: [
                                                        .restPresets
                                                       ],
                                                       isEnabled: true)
    
    static let developerSection: SettingsSection = .init(title: "DEVELOPER",
                                                         items: [
                                                            .designShowcase
                                                         ],
                                                         isEnabled: true)
    
    static let supportSection: SettingsSection = .init(title: "SUPPORT",
                                                       items: [
                                                        .submitFeedback,
                                                        .signOut
                                                       ],
                                                       isEnabled: true)
    
    static let sections: [SettingsSection] = [
        workoutSection,
        developerSection,
        supportSection
    ]
}
