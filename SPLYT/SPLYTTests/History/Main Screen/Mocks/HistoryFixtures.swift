//
//  HistoryFixtures.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 7/23/23.
//

@testable import DesignSystem

struct HistoryFixtures {
    typealias StateFixtures = WorkoutViewStateFixtures
    
    // MARK: - View States
    
    static let histories: [RoutineTileViewState] = [
        StateFixtures.legWorkoutHistoryRoutineTile,
        StateFixtures.fullBodyWorkoutHistoryRoutineTile
    ]
    
    static let deleteWorkoutHistoryDialog: DialogViewState = .init(title: "Delete workout history?",
                                                                   subtitle: "This will delete only this completed version of the workout. This action can't be undone.",
                                                                   primaryButtonTitle: "Delete",
                                                                   secondaryButtonTitle: "Cancel")
}
