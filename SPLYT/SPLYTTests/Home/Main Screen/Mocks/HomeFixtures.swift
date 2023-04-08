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
    
    static func createSets(id: String, inputs: [SetInput]) -> [Set] {
        var sets = [Set]()
        
        for (index, input) in inputs.enumerated() {
            let set = Set(id: "\(id)-set-\(index + 1)",
                          input: input,
                          modifier: nil)
            sets.append(set)
        }
        return sets
    }
    
    static func backSquat(inputs: [SetInput]) -> Exercise {
        return Exercise(id: "back-squat",
                        name: "Back Squat",
                        sets: createSets(id: "back-squat", inputs: inputs))
    }
    
    static func barLunges(inputs: [SetInput]) -> Exercise {
        return Exercise(id: "bar-lunges",
                        name: "Bar Lunges",
                        sets: createSets(id: "bar-lunges", inputs: inputs))
    }
    
    static func benchPress(inputs: [SetInput]) -> Exercise {
        return Exercise(id: "bench-press",
                        name: "Bench Press",
                        sets: createSets(id: "bench-press", inputs: inputs))
    }
    
    static func inclineDBRow(inputs: [SetInput]) -> Exercise {
        return Exercise(id: "incline-db-row",
                        name: "Incline Dumbbell Row",
                        sets: createSets(id: "incline-db-row", inputs: inputs))
    }
    
    static let repsWeight3Sets: [SetInput] = [
        .repsWeight(reps: 12, weight: 135),
        .repsWeight(reps: 10, weight: 140),
        .repsWeight(reps: 8, weight: 155)
    ]
    
    static let repsWeight4Sets: [SetInput] = [
        .repsWeight(reps: 12, weight: 135),
        .repsWeight(reps: 10, weight: 140),
        .repsWeight(reps: 8, weight: 155),
        .repsWeight(reps: 2, weight: 225)
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
    
    static let createPlanState: FABRowViewState = FABRowViewState(id: "plan",
                                                                  title: "CREATE NEW PLAN",
                                                                  imageName: "calendar")
    
    static let createWorkoutState: FABRowViewState = FABRowViewState(id: "workout",
                                                                     title: "CREATE NEW WORKOUT",
                                                                     imageName: "figure.strengthtraining.traditional")
    
    static let fabState: FABViewState = FABViewState(id: "fab",
                                                     createPlanState: createPlanState,
                                                     createWorkoutState: createWorkoutState)
    
    static let deleteDialog: DialogViewState = DialogViewState(title: "Delete workout?",
                                                               subtitle: "This action can't be undone.",
                                                               primaryButtonTitle: "Delete",
                                                               secondaryButtonTitle: "Cancel")
}
