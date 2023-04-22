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
        (.repsWeight(reps: 12, weight: 135), nil),
        (.repsWeight(reps: 10, weight: 140), nil),
        (.repsWeight(reps: 8, weight: 155),
            .dropSet(input: .repsWeight(reps: nil, weight: 100)))
    ]
    
    static let repsWeight4Sets: [(SetInput, SetModifier?)] = [
        (.repsWeight(reps: 12, weight: 135), nil),
        (.repsWeight(reps: 10, weight: 140), nil),
        (.repsWeight(reps: 8, weight: 155), nil),
        (.repsWeight(reps: 2, weight: 225), nil)
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
    
    static let loadedWorkouts: [Workout] = [legWorkout, fullBodyWorkout]
    
    // MARK: - View State
    
    static let navBar: NavigationBarViewState = NavigationBarViewState(title: "Home",
                                                                       size: .large,
                                                                       position: .left)
    
    static let segmentedControlTitles: [String] = ["WORKOUTS", "PLANS"]
    
    static let createdLegWorkout: CreatedWorkoutViewState = CreatedWorkoutViewState(id: "leg-workout",
                                                                                    title: "Legs",
                                                                                    subtitle: "2 exercises",
                                                                                    lastCompleted: nil)
    
    static let createdFullBodyWorkout: CreatedWorkoutViewState = CreatedWorkoutViewState(id: "full-body-workout",
                                                                                         title: "Full Body",
                                                                                         subtitle: "4 exercises",
                                                                                         lastCompleted: "Last completed: Feb 3, 2023")
    
    static let createdWorkouts: [CreatedWorkoutViewState] = [createdLegWorkout, createdFullBodyWorkout]
    
    static let createPlanState: FABRowViewState = FABRowViewState(title: "CREATE NEW PLAN",
                                                                  imageName: "calendar")
    
    static let createWorkoutState: FABRowViewState = FABRowViewState(title: "CREATE NEW WORKOUT",
                                                                     imageName: "figure.strengthtraining.traditional")
    
    static let fabState: FABViewState = FABViewState(createPlanState: createPlanState,
                                                     createWorkoutState: createWorkoutState)
    
    static let deleteDialog: DialogViewState = DialogViewState(title: "Delete workout?",
                                                               subtitle: "This action can't be undone.",
                                                               primaryButtonTitle: "Delete",
                                                               secondaryButtonTitle: "Cancel")
}
