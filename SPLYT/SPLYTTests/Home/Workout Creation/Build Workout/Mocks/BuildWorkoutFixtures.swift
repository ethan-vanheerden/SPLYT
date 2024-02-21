//
//  BuildWorkoutFixtures.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 2/1/23.
//

import Foundation
@testable import SPLYT
import DesignSystem
@testable import ExerciseCore

struct BuildWorkoutFixtures {
    typealias WorkoutFixtures = WorkoutModelFixtures
    
    // MARK: - Network Responses
    
    static let availableExerciseResponse: GetAvailableExercisesResponse = .init(exercises: loadedExercisesNoneSelected)
    
    static let favoritesResponse: FavoriteExercisesResponse = .init(userFavorites: [WorkoutFixtures.backSquatId])
    
    // MARK: - Domain
    
    static func backSquatAvailable(selectedGroups: [Int], isFavorite: Bool) -> AvailableExercise {
        return AvailableExercise(id: WorkoutFixtures.backSquatId,
                                 name: "Back Squat",
                                 musclesWorked: [.quads, .glutes],
                                 isFavorite: isFavorite,
                                 defaultInputType: .repsWeight(input: .init()),
                                 selectedGroups: selectedGroups)
    }
    
    static func benchPressAvailable(selectedGroups: [Int], isFavorite: Bool) -> AvailableExercise {
        return AvailableExercise(id: WorkoutFixtures.benchPressId,
                                 name: "Bench Press",
                                 musclesWorked: [.chest],
                                 isFavorite: isFavorite,
                                 defaultInputType: .repsWeight(input: .init()),
                                 selectedGroups: selectedGroups)
    }
    
    static func inclineDBRowAvailable(selectedGroups: [Int], isFavorite: Bool) -> AvailableExercise {
        return AvailableExercise(id: WorkoutFixtures.inclineRowId,
                                 name: "Incline Dumbbell Row",
                                 musclesWorked: [.back],
                                 isFavorite: isFavorite,
                                 defaultInputType: .repsWeight(input: .init()),
                                 selectedGroups: selectedGroups)
    }
    
    static let loadedExercisesNoneSelected: [AvailableExercise] = [
        backSquatAvailable(selectedGroups: [], isFavorite: false),
        benchPressAvailable(selectedGroups: [], isFavorite: false),
        inclineDBRowAvailable(selectedGroups: [], isFavorite: false)
    ]
    
    static let loadedExercisesNoneSelectedMap: [String: AvailableExercise] = [
        WorkoutFixtures.backSquatId: backSquatAvailable(selectedGroups: [], isFavorite: false),
        WorkoutFixtures.benchPressId: benchPressAvailable(selectedGroups: [], isFavorite: false),
        WorkoutFixtures.inclineRowId: inclineDBRowAvailable(selectedGroups: [], isFavorite: false)
    ]
    
    static let backSquatNoneSelectedMap: [String: AvailableExercise] = [
        WorkoutFixtures.backSquatId: backSquatAvailable(selectedGroups: [], isFavorite: false)
    ]
    
    static let workoutName = "Test Workout"
    
    static let workoutId = "Test Workout-2023-01-01T08:00:00Z"
    
    static func builtWorkout(exerciseGroups: [ExerciseGroup]) -> Workout {
        return Workout(id: workoutId,
                       name: workoutName,
                       exerciseGroups: exerciseGroups,
                       createdAt: WorkoutFixtures.jan_1_2023_0800,
                       lastCompleted: nil)
    }
    
    static var musclesWorkedMap: [MusclesWorked: Bool] {
        var musclesWorked = [MusclesWorked: Bool]()
        for muscle in MusclesWorked.allCases {
            musclesWorked[muscle] = false
        }
        return musclesWorked
    }
    
    static let emptyFilterDomain: BuildWorkoutFilterDomain = .init(searchText: "",
                                                                   isFavorite: false,
                                                                   musclesWorked: musclesWorkedMap)
    
    // MARK: - View States
    
    static func backSquatTileViewState(selectedGroups: [Int], isFavorite: Bool) -> AddExerciseTileViewState {
        return AddExerciseTileViewState(id: WorkoutFixtures.backSquatId,
                                        exerciseName: "Back Squat",
                                        selectedGroups: selectedGroups,
                                        isFavorite: isFavorite)
    }
    
    static func benchPressTileViewState(selectedGroups: [Int], isFavorite: Bool) -> AddExerciseTileViewState {
        return AddExerciseTileViewState(id: WorkoutFixtures.benchPressId,
                                        exerciseName: "Bench Press",
                                        selectedGroups: selectedGroups,
                                        isFavorite: isFavorite)
    }
    
    static func inclineDBRowTileViewState(selectedGroups: [Int], isFavorite: Bool) -> AddExerciseTileViewState {
        return AddExerciseTileViewState(id: WorkoutFixtures.inclineRowId,
                                        exerciseName: "Incline Dumbbell Row",
                                        selectedGroups: selectedGroups,
                                        isFavorite: isFavorite)
    }
    
    static let exerciseTilesNoneSelected: [AddExerciseTileSectionViewState] = [
        AddExerciseTileSectionViewState(header: .init(title: "B"),
                                        exercises: [
                                            backSquatTileViewState(selectedGroups: [], isFavorite: false),
                                            benchPressTileViewState(selectedGroups: [], isFavorite: false)
                                        ]),
        AddExerciseTileSectionViewState(header: .init(title: "I"),
                                        exercises: [
                                            inclineDBRowTileViewState(selectedGroups: [], isFavorite: false)
                                        ])
    ]
    
    static let exerciseTilesBackSquatSelected: [AddExerciseTileSectionViewState] = [
        AddExerciseTileSectionViewState(header: .init(title: "B"),
                                        exercises: [
                                            backSquatTileViewState(selectedGroups: [0], isFavorite: false),
                                            benchPressTileViewState(selectedGroups: [], isFavorite: false)
                                        ]),
        AddExerciseTileSectionViewState(header: .init(title: "I"),
                                        exercises: [
                                            inclineDBRowTileViewState(selectedGroups: [], isFavorite: false)
                                        ])
    ]
    
    static let dialogViewState: DialogViewState = DialogViewState(title: "Confirm Exit",
                                                                  subtitle: "If you exit now, all progress will be lost.",
                                                                  primaryButtonTitle: "Confirm",
                                                                  secondaryButtonTitle: "Cancel")
    
    static let backDialog: DialogViewState = DialogViewState(title: "Confirm Exit",
                                                             subtitle: "If you exit now, all progress will be lost.",
                                                             primaryButtonTitle: "Confirm",
                                                             secondaryButtonTitle: "Cancel")
    
    static let saveDialog: DialogViewState = DialogViewState(title: "Error saving",
                                                             subtitle: "Please try again later.",
                                                             primaryButtonTitle: "Ok")
    
    static let emptyFilterDisplay: BuildWorkoutFilterDisplay = .init(isFavorite: false,
                                                                     musclesWorked: musclesWorkedMap)
}
