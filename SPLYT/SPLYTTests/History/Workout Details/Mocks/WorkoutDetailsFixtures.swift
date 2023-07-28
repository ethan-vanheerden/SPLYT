//
//  WorkoutDetailsFixtures.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 7/28/23.
//

@testable import SPLYT
@testable import DesignSystem

struct WorkoutDetailsFixtures {
    typealias StateFixtures = WorkoutViewStateFixtures
    
    // MARK: - View States
    
    static let fullBodyWorkoutHistoryGroups: [CompletedExerciseGroupViewState] = [
        .init(header: .init(title: "Group 1",
                            color: .lightBlue),
              exercises: StateFixtures.fullBodyWorkoutExercisesCompleted(includeHeaderLine: true)[0]),
        .init(header: .init(title: "Group 2",
                            color: .lightBlue),
              exercises: StateFixtures.fullBodyWorkoutExercisesCompleted(includeHeaderLine: true)[1])
    ]
    
    static func display(presentedDialog: WorkoutDetailsDialog? = nil,
                        expandedGroups: [Bool] = [true, true]) -> WorkoutDetailsDisplay {
        return WorkoutDetailsDisplay(workoutName: StateFixtures.fullBodyWorkoutHistoryName,
                                     numExercisesTitle: "4 exercises",
                                     completedTitle: StateFixtures.fullBodyWorkoutHistoryCompletedTitle,
                                     groups: fullBodyWorkoutHistoryGroups,
                                     expandedGroups: expandedGroups,
                                     presentedDialog: presentedDialog,
                                     deleteDialog: HistoryFixtures.deleteWorkoutHistoryDialog)
    }
}
