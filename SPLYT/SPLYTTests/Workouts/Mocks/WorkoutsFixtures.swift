//
//  WorkoutsFixtures.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 12/29/22.
//

import Foundation
import DesignSystem
@testable import SPLYT

struct WorkoutsFixtures {
    
    static let createPlanState: FABRowViewState = FABRowViewState(id: "plan",
                                                                  title: "CREATE NEW PLAN",
                                                                  imageName: "calendar")
    
    static let createWorkoutState: FABRowViewState = FABRowViewState(id: "workout",
                                                                     title: "CREATE NEW WORKOUT",
                                                                     imageName: "figure.strengthtraining.traditional")
    
    static let fabState: FABViewState = FABViewState(id: "fab",
                                                     createPlanState: createPlanState,
                                                     createWorkoutState: createWorkoutState)
    
    static let mainDisplay: WorkoutsDisplayInfo = WorkoutsDisplayInfo(mainItems: [], fab: fabState)
}
