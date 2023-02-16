//
//  WorkoutsReducer.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 12/24/22.
//

import Foundation
import DesignSystem

final class WorkoutsReducer {
    func reduce(_ domain: WorkoutsDomainResult) -> WorkoutsViewState {
        switch domain {
        case .error:
            return .error
        case .loaded(let exercises):
            return reduceLoaded(exercises: exercises)
        }
    }
}

// MARK: - Private

private extension WorkoutsReducer {
    func reduceLoaded(exercises: [String]) -> WorkoutsViewState {
        let fabState = getFABState()
        let display = WorkoutsDisplayInfo(mainItems: [], fab: fabState)
        return .main(display)
    }
    
    func getFABState() -> FABViewState {
        let createPlanState = FABRowViewState(id: "plan",
                                              title: "CREATE NEW PLAN",
                                              imageName: "calendar")
        let createWorkoutState = FABRowViewState(id: "workout",
                                                 title: "CREATE NEW WORKOUT",
                                                 imageName: "figure.strengthtraining.traditional")
        
        return FABViewState(id: "fab",
                            createPlanState: createPlanState,
                            createWorkoutState: createWorkoutState)
    }
}
