//
//  HomeFixtures.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 12/29/22.
//

import Foundation
import DesignSystem
@testable import ExerciseCore
@testable import SPLYT

struct HomeFixtures {
    typealias ModelFixtures = WorkoutModelFixtures
    
    // MARK: - View States
    
    static let navBar: NavigationBarViewState = NavigationBarViewState(title: "🏠 Home",
                                                                       size: .large,
                                                                       position: .left)
    
    static let segmentedControlTitles: [String] = ["WORKOUTS", "PLANS"]
    
    static let createPlanFABState: HomeFABRowViewState = HomeFABRowViewState(title: "CREATE NEW PLAN",
                                                                          imageName: "calendar")
    
    static let createWorkoutFABState: HomeFABRowViewState = HomeFABRowViewState(title: "CREATE NEW WORKOUT",
                                                                             imageName: "figure.strengthtraining.traditional")
    
    static let fabState: HomeFABViewState = HomeFABViewState(createPlanState: createPlanFABState,
                                                             createWorkoutState: createWorkoutFABState)
    
    static let deleteWorkoutDialog: DialogViewState = DialogViewState(title: "Delete workout?",
                                                                      subtitle: "This action can't be undone.",
                                                                      primaryButtonTitle: "Delete",
                                                                      secondaryButtonTitle: "Cancel")
    
    static let deletePlanDialog: DialogViewState = DialogViewState(title: "Delete plan?",
                                                                   subtitle: "This will also delete all of the associated workouts. This action can't be undone.",
                                                                   primaryButtonTitle: "Delete",
                                                                   secondaryButtonTitle: "Cancel")
}
