//
//  BuildPlanFixtures.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 7/15/23.
//

import Foundation
@testable import SPLYT
import DesignSystem
@testable import ExerciseCore

struct BuildPlanFixtures {
    typealias WorkoutFixtures = WorkoutModelFixtures
    
    // MARK: - View States
    
    static let backDisloag: DialogViewState = .init(title: "Confirm Exit",
                                                    subtitle: "If you exit now, all progress will be lost.",
                                                    primaryButtonTitle: "Confirm",
                                                    secondaryButtonTitle: "Cancel")
    
    static let saveDialog: DialogViewState = .init(title: "Save Plan?",
                                                   subtitle: "Your plan will be saved to your routines.",
                                                   primaryButtonTitle: "Confirm",
                                                   secondaryButtonTitle: "Cancel")
    
    static let deleteDialog: DialogViewState = .init(title: "Delete workout?",
                                                     subtitle: "This action can't be undone.",
                                                     primaryButtonTitle: "Delete",
                                                     secondaryButtonTitle: "Cancel")
}
