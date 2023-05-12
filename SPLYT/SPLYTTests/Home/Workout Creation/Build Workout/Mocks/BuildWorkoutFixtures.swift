//
//  BuildWorkoutFixtures.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 2/1/23.
//

import Foundation
@testable import SPLYT
import DesignSystem
import ExerciseCore

struct BuildWorkoutFixtures {
    
    // MARK: - Domain
    
    static func backSquatAvailable(isSelected: Bool, isFavorite: Bool) -> AvailableExercise {
        return AvailableExercise(id: "back-squat",
                                 name: "Back Squat",
                                 musclesWorked: [.quads, .glutes],
                                 isFavorite: isFavorite,
                                 defaultInputType: .repsWeight(input: .init()),
                                 isSelected: isSelected)
    }
    
    static func benchPressAvailable(isSelected: Bool, isFavorite: Bool) -> AvailableExercise {
        return AvailableExercise(id: "bench-press",
                                 name: "Bench Press",
                                 musclesWorked: [.chest],
                                 isFavorite: isFavorite,
                                 defaultInputType: .repsWeight(input: .init()),
                                 isSelected: isSelected)
    }
    
    static func inclineDBRowAvailable(isSelected: Bool, isFavorite: Bool) -> AvailableExercise {
        return AvailableExercise(id: "incline-db-row",
                                 name: "Incline Dumbbell Row",
                                 musclesWorked: [.back],
                                 isFavorite: isFavorite,
                                 defaultInputType: .repsWeight(input: .init()),
                                 isSelected: isSelected)
    }
    
    static let loadedExercisesNoneSelected: [AvailableExercise] = [
        backSquatAvailable(isSelected: false, isFavorite: false),
        benchPressAvailable(isSelected: false, isFavorite: false),
        inclineDBRowAvailable(isSelected: false, isFavorite: false)
    ]
    
    static let loadedExercisesNoneSelectedMap: [String: AvailableExercise] = [
        "back-squat": backSquatAvailable(isSelected: false, isFavorite: false),
        "bench-press": benchPressAvailable(isSelected: false, isFavorite: false),
        "incline-db-row": inclineDBRowAvailable(isSelected: false, isFavorite: false)
    ]
    
    static let workoutName = "Test Workout"
    
    static func builtWorkout(exerciseGroups: [ExerciseGroup]) -> Workout {
        return Workout(id: "Test Workout-2023-01-01T08:00:00Z",
                       name: workoutName,
                       exerciseGroups: exerciseGroups,
                       lastCompleted: nil)
    }
    
    static func exerciseGroups(numGroups: Int, groupExercises: [Int: [Exercise]]) -> [ExerciseGroup] {
        var groups = [ExerciseGroup]()
        
        for i in stride(from: 0, to: numGroups, by: 1) {
            let exercises = groupExercises[i]!
            groups.append(ExerciseGroup(exercises: exercises))
        }
        return groups
    }
    
    // MARK: - View State
    
    static func backSquatTileViewState(isSelected: Bool, isFavorite: Bool) -> AddExerciseTileViewState {
        return AddExerciseTileViewState(id: "back-squat",
                                        exerciseName: "Back Squat",
                                        isSelected: isSelected,
                                        isFavorite: isFavorite)
    }
    
    static func benchPressTileViewState(isSelected: Bool, isFavorite: Bool) -> AddExerciseTileViewState {
        return AddExerciseTileViewState(id: "bench-press",
                                        exerciseName: "Bench Press",
                                        isSelected: isSelected,
                                        isFavorite: isFavorite)
    }
    
    static func inclineDBRowTileViewState(isSelected: Bool, isFavorite: Bool) -> AddExerciseTileViewState {
        return AddExerciseTileViewState(id: "incline-db-row",
                                        exerciseName: "Incline Dumbbell Row",
                                        isSelected: isSelected,
                                        isFavorite: isFavorite)
    }
    
    static let exerciseTilesNoneSelected: [AddExerciseTileViewState] = [
        backSquatTileViewState(isSelected: false, isFavorite: false),
        benchPressTileViewState(isSelected: false, isFavorite: false),
        inclineDBRowTileViewState(isSelected: false, isFavorite: false)
    ]
    
    static func createSetViewStates(inputs: [(SetInputViewState, SetModifierViewState?)]) -> [SetViewState] {
        var sets = [SetViewState]()
        
        for (index, (input, modifier)) in inputs.enumerated() {
            let set = SetViewState(setIndex: index,
                                   title: "Set \(index + 1)",
                                   type: input,
                                   modifier: modifier)
            sets.append(set)
        }
        return sets
    }
    
    static func backSquatViewState(inputs: [(SetInputViewState, SetModifierViewState?)]) -> ExerciseViewState {
        let header = SectionHeaderViewState(text: "Back Squat")
        return ExerciseViewState(header: header,
                                 sets: createSetViewStates(inputs: inputs),
                                 canRemoveSet: inputs.count > 1)
    }
    
    static func benchPressViewState(inputs: [(SetInputViewState, SetModifierViewState?)]) -> ExerciseViewState {
        let header = SectionHeaderViewState(text: "Bench Press")
        return ExerciseViewState(header: header,
                                 sets: createSetViewStates(inputs: inputs),
                                 canRemoveSet: inputs.count > 1)
    }
    
    static func inclineDBRowViewState(inputs: [(SetInputViewState, SetModifierViewState?)]) -> ExerciseViewState {
        let header = SectionHeaderViewState(text: "Incline Dumbbell Row")
        return ExerciseViewState(header: header,
                                 sets: createSetViewStates(inputs: inputs),
                                 canRemoveSet: inputs.count > 1)
    }
    
    static var dialogViewState: DialogViewState = DialogViewState(title: "Confirm Exit",
                                                                  subtitle: "If you exit now, all progress will be lost.",
                                                                  primaryButtonTitle: "Confirm",
                                                                  secondaryButtonTitle: "Cancel")
    
    static var backDialog: DialogViewState = DialogViewState(title: "Confirm Exit",
                                                             subtitle: "If you exit now, all progress will be lost.",
                                                             primaryButtonTitle: "Confirm",
                                                             secondaryButtonTitle: "Cancel")
    
    static var saveDialog: DialogViewState = DialogViewState(title: "Error saving",
                                                             subtitle: "Please try again later.",
                                                             primaryButtonTitle: "Ok")
    
    static let reps = "reps"
    
    static let lbs = "lbs"
    
    static let sec = "sec"
    
    static let emptyRepsWeightSet: SetInputViewState = .repsWeight(weightTitle: lbs, repsTitle: reps)
}
