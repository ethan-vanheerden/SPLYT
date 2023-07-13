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
    
    // MARK: - View State
    
    static let navBar: NavigationBarViewState = NavigationBarViewState(title: "Home",
                                                                       size: .large,
                                                                       position: .left)
    
    static let segmentedControlTitles: [String] = ["WORKOUTS", "PLANS"]
    
    static let createdLegWorkoutViewState: RoutineTileViewState = RoutineTileViewState(id: ModelFixtures.legWorkoutId,
                                                                                       historyFilename: ModelFixtures.legWorkoutFilename,
                                                                                       title: "Legs",
                                                                                       subtitle: "2 exercises",
                                                                                       lastCompletedTitle: nil)
    
    static let createdFullBodyWorkoutViewState: RoutineTileViewState = RoutineTileViewState(id: ModelFixtures.fullBodyWorkoutId,
                                                                                            historyFilename: ModelFixtures.fullBodyWorkoutFilename,
                                                                                            title: "Full Body",
                                                                                            subtitle: "4 exercises",
                                                                                            lastCompletedTitle: "Last completed: Feb 3, 2023")
    
    static let createdWorkoutViewStates: [RoutineTileViewState] = [
        createdLegWorkoutViewState,
        createdFullBodyWorkoutViewState
    ]
    
    static let createPlanState: HomeFABRowViewState = HomeFABRowViewState(title: "CREATE NEW PLAN",
                                                                          imageName: "calendar")
    
    static let createWorkoutState: HomeFABRowViewState = HomeFABRowViewState(title: "CREATE NEW WORKOUT",
                                                                             imageName: "figure.strengthtraining.traditional")
    
    static let fabState: HomeFABViewState = HomeFABViewState(createPlanState: createPlanState,
                                                             createWorkoutState: createWorkoutState)
    
    static let deleteWorkoutDialog: DialogViewState = DialogViewState(title: "Delete workout?",
                                                                      subtitle: "This action can't be undone.",
                                                                      primaryButtonTitle: "Delete",
                                                                      secondaryButtonTitle: "Cancel")
    
    static let deletePlanDialog: DialogViewState = DialogViewState(title: "Delete plan?",
                                                                   subtitle: "This will also delete all of the associated workouts. This action can't be undone.",
                                                                   primaryButtonTitle: "Delete",
                                                                   secondaryButtonTitle: "Cancel")
}
