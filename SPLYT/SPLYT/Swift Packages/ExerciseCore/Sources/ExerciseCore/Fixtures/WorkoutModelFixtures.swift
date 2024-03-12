import Foundation

// TODO: move to test target but XCode is broken
/// Contains test models for things related to workouts.
public struct WorkoutModelFixtures {
    public static let dec_27_2022_1000: Date = Date(timeIntervalSince1970: 1672135200)
    
    public static let jan_1_2023_0800: Date = Date(timeIntervalSince1970: 1672560000)
    
    public static let feb_3_2023_1630: Date = Date(timeIntervalSince1970: 1675441800)
    
    public static let mar_8_2002_1200: Date = Date(timeIntervalSince1970: 1015606800)
    
    public static let oct_16_2000_0000: Date = Date(timeIntervalSince1970: 971668800)
    
    public static func createSets(inputs: [(SetInput, SetModifier?)]) -> [Set] {
        var sets = [Set]()
        
        for (input, modifier) in inputs {
            let set = Set(input: input,
                          modifier: modifier)
            sets.append(set)
        }
        return sets
    }
    
    public static let backSquatId = "back-squat"
    
    public static let barLungesId = "bar-lunges"
    
    public static let benchPressId = "bench-press"
    
    public static let inclineRowId = "incline-db-row"
    
    public static func backSquat(inputs: [(SetInput, SetModifier?)]) -> Exercise {
        return Exercise(id: backSquatId,
                        name: "Back Squat",
                        sets: createSets(inputs: inputs))
    }
    
    public static func barLunges(inputs: [(SetInput, SetModifier?)]) -> Exercise {
        return Exercise(id: barLungesId,
                        name: "Bar Lunges",
                        sets: createSets(inputs: inputs))
    }
    
    public static func benchPress(inputs: [(SetInput, SetModifier?)]) -> Exercise {
        return Exercise(id: benchPressId,
                        name: "Bench Press",
                        sets: createSets(inputs: inputs))
    }
    
    public static func inclineDBRow(inputs: [(SetInput, SetModifier?)]) -> Exercise {
        return Exercise(id: inclineRowId,
                        name: "Incline Dumbbell Row",
                        sets: createSets(inputs: inputs))
    }
    
    public static let repsWeight3Sets: [(SetInput, SetModifier?)] = [
        (.repsWeight(input: .init(weight: 135, weightPlaceholder: 100, reps: 12)), nil),
        (.repsWeight(input: .init(weight: 140, reps: 10)), nil),
        (.repsWeight(input: .init(weight: 155, reps: 8)),
         .dropSet(input: .repsWeight(input: .init(weight: 100,
                                                  repsPlaceholder: 5))))
    ]
    
    public static let repsWeight3SetsPlaceholders: [(SetInput, SetModifier?)] = [
        (.repsWeight(input: .init(weightPlaceholder: 135, repsPlaceholder: 12)), nil),
        (.repsWeight(input: .init(weightPlaceholder: 140, repsPlaceholder: 10)), nil),
        (.repsWeight(input: .init(weightPlaceholder: 155, repsPlaceholder: 8)),
         .dropSet(input: .repsWeight(input: .init(weightPlaceholder: 100,
                                                  repsPlaceholder: 5))))
    ]
    
    public static let repsWeight4Sets: [(SetInput, SetModifier?)] = [
        (.repsWeight(input: .init(weight: 135, weightPlaceholder: 100, reps: 12)), nil),
        (.repsWeight(input: .init(weight: 140, reps: 10)), nil),
        (.repsWeight(input: .init(weight: 155, reps: 8)), nil),
        (.repsWeight(input: .init(weight: 225, reps: 2, repsPlaceholder: 0)), nil)
    ]
    
    public static let repsWeight4SetsPlaceholders: [(SetInput, SetModifier?)] = [
        (.repsWeight(input: .init(weightPlaceholder: 135, repsPlaceholder: 12)), nil),
        (.repsWeight(input: .init(weightPlaceholder: 140, repsPlaceholder: 10)), nil),
        (.repsWeight(input: .init(weightPlaceholder: 155, repsPlaceholder: 8)), nil),
        (.repsWeight(input: .init(weightPlaceholder: 225, repsPlaceholder: 2)), nil)
    ]
    
    public static let legWorkoutExercises: [ExerciseGroup] = [
        ExerciseGroup(exercises: [backSquat(inputs: repsWeight4Sets)]),
        ExerciseGroup(exercises: [barLunges(inputs: repsWeight3Sets)])
    ]
    
    /// What the planned workout will be transformed into when we do a workout
    public static let legWorkoutExercises_WorkoutStart: [ExerciseGroup] = [
        ExerciseGroup(exercises: [backSquat(inputs: repsWeight4SetsPlaceholders)]),
        ExerciseGroup(exercises: [barLunges(inputs: repsWeight3SetsPlaceholders)])
    ]
    
    public static let fullBodyWorkoutExercises: [ExerciseGroup] = [
        ExerciseGroup(exercises: [
            backSquat(inputs: repsWeight3Sets),
            benchPress(inputs: repsWeight3Sets)
        ]),
        ExerciseGroup(exercises: [
            barLunges(inputs: repsWeight3Sets),
            inclineDBRow(inputs: repsWeight3Sets)
        ])
    ]
    
    public static let fullBodyWorkoutExercises_WorkoutStart: [ExerciseGroup] = [
        ExerciseGroup(exercises: [
            backSquat(inputs: repsWeight3SetsPlaceholders),
            benchPress(inputs: repsWeight3SetsPlaceholders)
        ]),
        ExerciseGroup(exercises: [
            barLunges(inputs: repsWeight3SetsPlaceholders),
            inclineDBRow(inputs: repsWeight3SetsPlaceholders)
        ])
    ]
    
    
    public static let legWorkoutId = "leg-workout"
    
    public static let legWorkoutHistoryId = "\(legWorkoutId)-history"
    
    public static let legWorkoutName = "Legs"
    
    public static let fullBodyWorkoutId = "full-body-workout"
    
    public static let  fullBodyWorkoutHistoryId = "\(fullBodyWorkoutId)-history"
    
    public static let fullBodyWorkoutName = "Full Body"
    
    public static let legWorkout: Workout = Workout(id: legWorkoutId,
                                             name: legWorkoutName,
                                             exerciseGroups: legWorkoutExercises,
                                             createdAt: feb_3_2023_1630,
                                             lastCompleted: nil)
    
    public static let legWorkout_WorkoutStart: Workout = Workout(id: legWorkoutId,
                                                          name: legWorkoutName,
                                                          exerciseGroups: legWorkoutExercises_WorkoutStart,
                                                          createdAt: feb_3_2023_1630,
                                                          lastCompleted: nil)
    
    public static let legWorkout_WorkoutHistory: WorkoutHistory = .init(id: legWorkoutHistoryId,
                                                                 workout: legWorkout)
    
    public static let fullBodyWorkout: Workout = Workout(id: fullBodyWorkoutId,
                                                  name: fullBodyWorkoutName,
                                                  exerciseGroups: fullBodyWorkoutExercises,
                                                  planName: myPlanName,
                                                  createdAt: jan_1_2023_0800,
                                                  lastCompleted: feb_3_2023_1630)
    
    public static let fullBodyWorkout_WorkoutStart: Workout = Workout(id: fullBodyWorkoutId,
                                                               name: fullBodyWorkoutName,
                                                               exerciseGroups: fullBodyWorkoutExercises_WorkoutStart,
                                                               planName: myPlanName,
                                                               createdAt: jan_1_2023_0800,
                                                               lastCompleted: feb_3_2023_1630)
    
    public static let fullBodyWorkout_WorkoutHistory: WorkoutHistory = .init(id: fullBodyWorkoutHistoryId,
                                                                      workout: fullBodyWorkout)
    
    public static let loadedWorkouts: [String: Workout] = [
        legWorkoutId: legWorkout,
        fullBodyWorkoutId: fullBodyWorkout
    ]
    
    public static let workoutHistories: [WorkoutHistory] = [
        legWorkout_WorkoutHistory,
        fullBodyWorkout_WorkoutHistory
    ]
    
    public static let myPlanName = "My Plan 1"
    
    public static let myPlanId = "\(myPlanName)-2023-01-01T08:00:00Z"
    
    public static let myPlanEmpty: Plan = Plan(id: myPlanId,
                                        name: myPlanName,
                                        workouts: [],
                                        createdAt: jan_1_2023_0800,
                                        lastCompleted: nil)
    
    public static let myPlan: Plan = Plan(id: myPlanId,
                                   name: myPlanName,
                                   workouts: [
                                    legWorkout,
                                    fullBodyWorkout
                                   ],
                                   createdAt: jan_1_2023_0800,
                                   lastCompleted: feb_3_2023_1630)
    
    public static let loadedPlans: [String: Plan] = [
        myPlanId: myPlan
    ]
    
    public static let loadedRoutines: CreatedRoutines = CreatedRoutines(workouts: loadedWorkouts,
                                                                 plans: loadedPlans)
    
    public static func exerciseGroups(numGroups: Int, groupExercises: [Int: [Exercise]]) -> [ExerciseGroup] {
        var groups = [ExerciseGroup]()
        
        for i in stride(from: 0, to: numGroups, by: 1) {
            let exercises = groupExercises[i]!
            groups.append(ExerciseGroup(exercises: exercises))
        }
        return groups
    }
}
