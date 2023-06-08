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
    
    // MARK: - Domain
    
    static let jan_1_2023_0800: Date = Date(timeIntervalSince1970: 1672560000)
    
    static let feb_3_2023_1630: Date = Date(timeIntervalSince1970: 1675441800)
    
    static func createSets(inputs: [(SetInput, SetModifier?)]) -> [Set] {
        var sets = [Set]()
        
        for (input, modifier) in inputs {
            let set = Set(input: input,
                          modifier: modifier)
            sets.append(set)
        }
        return sets
    }
    
    static func backSquat(inputs: [(SetInput, SetModifier?)]) -> Exercise {
        return Exercise(id: "back-squat",
                        name: "Back Squat",
                        sets: createSets(inputs: inputs))
    }
    
    static func barLunges(inputs: [(SetInput, SetModifier?)]) -> Exercise {
        return Exercise(id: "bar-lunges",
                        name: "Bar Lunges",
                        sets: createSets(inputs: inputs))
    }
    
    static func benchPress(inputs: [(SetInput, SetModifier?)]) -> Exercise {
        return Exercise(id: "bench-press",
                        name: "Bench Press",
                        sets: createSets(inputs: inputs))
    }
    
    static func inclineDBRow(inputs: [(SetInput, SetModifier?)]) -> Exercise {
        return Exercise(id: "incline-db-row",
                        name: "Incline Dumbbell Row",
                        sets: createSets(inputs: inputs))
    }
    
    static let repsWeight3Sets: [(SetInput, SetModifier?)] = [
        (.repsWeight(input: .init(weight: 135, reps: 12)), nil),
        (.repsWeight(input: .init(weight: 140, reps: 10)), nil),
        (.repsWeight(input: .init(weight: 155, reps: 8)),
         .dropSet(input: .repsWeight(input: .init(weight: 100))))
    ]
    
    static let repsWeight4Sets: [(SetInput, SetModifier?)] = [
        (.repsWeight(input: .init(weight: 135, reps: 12)), nil),
        (.repsWeight(input: .init(weight: 140, reps: 10)), nil),
        (.repsWeight(input: .init(weight: 155, reps: 8)), nil),
        (.repsWeight(input: .init(weight: 225, reps: 2)), nil)
    ]
    
    static let legWorkoutExercises: [ExerciseGroup] = [
        ExerciseGroup(exercises: [backSquat(inputs: repsWeight4Sets)]),
        ExerciseGroup(exercises: [barLunges(inputs: repsWeight3Sets)])
    ]
    
    static let fullBodyWorkoutExercises: [ExerciseGroup] = [
        ExerciseGroup(exercises: [backSquat(inputs: repsWeight3Sets), benchPress(inputs: repsWeight3Sets)]),
        ExerciseGroup(exercises: [barLunges(inputs: repsWeight3Sets), inclineDBRow(inputs: repsWeight3Sets)])
    ]
    
    static let legWorkout: Workout = Workout(id: "leg-workout",
                                             name: "Legs",
                                             exerciseGroups: legWorkoutExercises,
                                             lastCompleted: nil)
    
    static let fullBodyWorkout: Workout = Workout(id: "full-body-workout",
                                                  name: "Full Body",
                                                  exerciseGroups: fullBodyWorkoutExercises,
                                                  lastCompleted: feb_3_2023_1630)
    
    static let createdLegWorkout: CreatedWorkout = CreatedWorkout(workout: legWorkout,
                                                                  filename: "workout_history_leg-workout",
                                                                  createdAt: feb_3_2023_1630)
    
    static let createdFullBodyWorkout: CreatedWorkout = CreatedWorkout(workout: fullBodyWorkout,
                                                                       filename: "workout_history_full=body-workout",
                                                                       createdAt: jan_1_2023_0800)
    
    static let loadedCreatedWorkouts: [String: CreatedWorkout] = [
        "leg-workout": createdLegWorkout,
        "full-body-workout": createdFullBodyWorkout
    ]
    
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
