import Foundation

// TODO: move to test target but xcode is broken
/// Contains test models for things related to workouts.
struct WorkoutModelFixtures {
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
        (.repsWeight(input: .init(weight: 135, weightPlaceholder: 100, reps: 12)), nil),
        (.repsWeight(input: .init(weight: 140, reps: 10)), nil),
        (.repsWeight(input: .init(weight: 155, reps: 8)),
         .dropSet(input: .repsWeight(input: .init(weight: 100))))
    ]
    
    static let repsWeight4Sets: [(SetInput, SetModifier?)] = [
        (.repsWeight(input: .init(weight: 135, weightPlaceholder: 100, reps: 12)), nil),
        (.repsWeight(input: .init(weight: 140, reps: 10)), nil),
        (.repsWeight(input: .init(weight: 155, reps: 8)), nil),
        (.repsWeight(input: .init(weight: 225, reps: 2, repsPlaceholder: 0)), nil)
    ]
    
    static let legWorkoutExercises: [ExerciseGroup] = [
        ExerciseGroup(exercises: [backSquat(inputs: repsWeight4Sets)]),
        ExerciseGroup(exercises: [barLunges(inputs: repsWeight3Sets)])
    ]
    
    static let fullBodyWorkoutExercises: [ExerciseGroup] = [
        ExerciseGroup(exercises: [backSquat(inputs: repsWeight3Sets), benchPress(inputs: repsWeight3Sets)]),
        ExerciseGroup(exercises: [barLunges(inputs: repsWeight3Sets), inclineDBRow(inputs: repsWeight3Sets)])
    ]
    
    static let legWorkoutId = "leg-workout"
    
    static let fullBodyWorkoutId = "full-body-workout"
    
    static let legWorkout: Workout = Workout(id: legWorkoutId,
                                             name: "Legs",
                                             exerciseGroups: legWorkoutExercises,
                                             lastCompleted: nil)
    
    static let fullBodyWorkout: Workout = Workout(id: fullBodyWorkoutId,
                                                  name: "Full Body",
                                                  exerciseGroups: fullBodyWorkoutExercises,
                                                  lastCompleted: feb_3_2023_1630)
    
    static let legWorkoutFilename = "workout_history_leg-workout"
    
    static let fullBodyWorkoutFilename = "workout_history_full-body-workout"
    
    static let createdLegWorkout: CreatedWorkout = CreatedWorkout(workout: legWorkout,
                                                                  filename: legWorkoutFilename,
                                                                  createdAt: feb_3_2023_1630)
    
    static let createdFullBodyWorkout: CreatedWorkout = CreatedWorkout(workout: fullBodyWorkout,
                                                                       filename: fullBodyWorkoutFilename,
                                                                       createdAt: jan_1_2023_0800)
    
    static let loadedCreatedWorkouts: [String: CreatedWorkout] = [
        legWorkoutId: createdLegWorkout,
        fullBodyWorkoutId: createdFullBodyWorkout
    ]
    
    static func exerciseGroups(numGroups: Int, groupExercises: [Int: [Exercise]]) -> [ExerciseGroup] {
        var groups = [ExerciseGroup]()
        
        for i in stride(from: 0, to: numGroups, by: 1) {
            let exercises = groupExercises[i]!
            groups.append(ExerciseGroup(exercises: exercises))
        }
        return groups
    }
}
