//
//  HomeFixtures.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 12/29/22.
//

import Foundation
import DesignSystem
import ExerciseCore
@testable import SPLYT

struct HomeFixtures {

    // MARK: - View State
    
    static let navBar: NavigationBarViewState = NavigationBarViewState(title: "Home",
                                                                       size: .large,
                                                                       position: .left)
    
    static let segmentedControlTitles: [String] = ["WORKOUTS", "PLANS"]
    
    static let createdLegWorkoutViewState: CreatedWorkoutViewState = CreatedWorkoutViewState(id: "leg-workout",
                                                                                             filename: "workout_history_leg-workout",
                                                                                             title: "Legs",
                                                                                             subtitle: "2 exercises",
                                                                                             lastCompleted: nil)
    
    static let createdFullBodyWorkoutViewState: CreatedWorkoutViewState = CreatedWorkoutViewState(id: "full-body-workout",
                                                                                                  filename: "workout_history_full=body-workout",
                                                                                                  title: "Full Body",
                                                                                                  subtitle: "4 exercises",
                                                                                                  lastCompleted: "Last completed: Feb 3, 2023")
    
    static let createdWorkoutViewStates: [CreatedWorkoutViewState] = [
        createdLegWorkoutViewState,
        createdFullBodyWorkoutViewState
    ]
    
    static let createPlanState: HomeFABRowViewState = HomeFABRowViewState(title: "CREATE NEW PLAN",
                                                                          imageName: "calendar")
    
    static let createWorkoutState: HomeFABRowViewState = HomeFABRowViewState(title: "CREATE NEW WORKOUT",
                                                                             imageName: "figure.strengthtraining.traditional")
    
    static let fabState: HomeFABViewState = HomeFABViewState(createPlanState: createPlanState,
                                                             createWorkoutState: createWorkoutState)
    
    static let deleteDialog: DialogViewState = DialogViewState(title: "Delete workout?",
                                                               subtitle: "This action can't be undone.",
                                                               primaryButtonTitle: "Delete",
                                                               secondaryButtonTitle: "Cancel")
}
