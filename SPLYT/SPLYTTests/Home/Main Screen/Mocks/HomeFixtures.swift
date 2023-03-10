//
//  HomeFixtures.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 12/29/22.
//

import Foundation
import DesignSystem
@testable import SPLYT

struct HomeFixtures {
    
    // MARK: - Domain
    
    static let jan_1_2023_0800: Date = Date(timeIntervalSince1970: 1672560000)
    
    static let feb_3_2023_1630: Date = Date(timeIntervalSince1970: 1675441800)
    
    static func createSets(id: String, numSets: Int) -> [Set] {
        var sets = [Set]()
        
        for i in 1...numSets {
            let set = Set(id: "\(id)-set-\(i)",
                          inputType: .repsWeight(reps: nil, weight: nil),
                          modifier: nil)
            sets.append(set)
        }
        return sets
    }
    
    static func backSquat(numSets: Int) -> Exercise {
        return Exercise(id: "back-squat",
                        name: "Back Squat",
                        sets: createSets(id: "back-squat", numSets: numSets))
    }
    
    static func barLunges(numSets: Int) -> Exercise {
        return Exercise(id: "bar-lunges",
                        name: "Bar Lunges",
                        sets: createSets(id: "bar-lunges", numSets: numSets))
    }
    
    static func benchPress(numSets: Int) -> Exercise {
        return Exercise(id: "bench-press",
                        name: "Bench Press",
                        sets: createSets(id: "bench-press", numSets: numSets))
    }
    
    static func inclineDBRow(numSets: Int) -> Exercise {
        return Exercise(id: "incline-db-row",
                        name: "Incline Dumbbell Row",
                        sets: createSets(id: "incline-db-row", numSets: numSets))
    }
    
    static let legWorkoutExercises: [ExerciseGroup] = [
        ExerciseGroup(exercises: [backSquat(numSets: 4)]),
        ExerciseGroup(exercises: [barLunges(numSets: 3)])
    ]
    
    static let fullBodyWorkoutExercises: [ExerciseGroup] = [
        ExerciseGroup(exercises: [backSquat(numSets: 3), benchPress(numSets: 3)]),
        ExerciseGroup(exercises: [barLunges(numSets: 3), inclineDBRow(numSets: 3)])
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
