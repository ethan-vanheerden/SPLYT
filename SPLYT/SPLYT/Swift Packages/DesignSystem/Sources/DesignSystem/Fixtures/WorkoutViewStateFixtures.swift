import ExerciseCore

// TODO: this needs to be moved to the test target but xcode is broken
/// Contains test view states for things related to workouts.
public struct WorkoutViewStateFixtures {
    public typealias ModelFixtures = WorkoutModelFixtures
    
    public static let reps = "reps"
    
    public static let lbs = "lbs"
    
    public static let sec = "sec"
    
    public static func createSetViewStates(inputs: [(SetInputViewState, SetModifierViewState?)]) -> [SetViewState] {
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
    
    public static func createCompletedSetViewStates(inputs: [(SetInputViewState, SetModifierViewState?)]) -> [CompletedSetViewState] {
        var sets = [CompletedSetViewState]()
        
        for (index, (input, modifier)) in inputs.enumerated() {
            let set = CompletedSetViewState(title: "Set \(index + 1)",
                                            type: input,
                                            modifier: modifier)
            sets.append(set)
        }
        return sets
    }
    
    public static func backSquatViewState(inputs: [(SetInputViewState, SetModifierViewState?)],
                                          includeHeaderLine: Bool = true) -> ExerciseViewState {
        let header = SectionHeaderViewState(title: "Back Squat",
                                            includeLine: includeHeaderLine)
        return ExerciseViewState(header: header,
                                 sets: createSetViewStates(inputs: inputs),
                                 canRemoveSet: inputs.count > 1)
    }
    
    public static func barLungesViewState(inputs: [(SetInputViewState, SetModifierViewState?)],
                                          includeHeaderLine: Bool = true) -> ExerciseViewState {
        let header = SectionHeaderViewState(title: "Bar Lunges",
                                            includeLine: includeHeaderLine)
        return ExerciseViewState(header: header,
                                 sets: createSetViewStates(inputs: inputs),
                                 canRemoveSet: inputs.count > 1)
    }
    
    public static func benchPressViewState(inputs: [(SetInputViewState, SetModifierViewState?)],
                                           includeHeaderLine: Bool = true) -> ExerciseViewState {
        let header = SectionHeaderViewState(title: "Bench Press",
                                            includeLine: includeHeaderLine)
        return ExerciseViewState(header: header,
                                 sets: createSetViewStates(inputs: inputs),
                                 canRemoveSet: inputs.count > 1)
    }
    
    public static func inclineDBRowViewState(inputs: [(SetInputViewState, SetModifierViewState?)],
                                             includeHeaderLine: Bool = true) -> ExerciseViewState {
        let header = SectionHeaderViewState(title: "Incline Dumbbell Row",
                                            includeLine: includeHeaderLine)
        return ExerciseViewState(header: header,
                                 sets: createSetViewStates(inputs: inputs),
                                 canRemoveSet: inputs.count > 1)
    }
    
    public static func backSquatViewStateCompleted(inputs: [(SetInputViewState, SetModifierViewState?)],
                                                   includeHeaderLine: Bool = true) -> CompletedExerciseViewState {
        let header = SectionHeaderViewState(title: "Back Squat",
                                            includeLine: includeHeaderLine)
        return CompletedExerciseViewState(header: header,
                                          sets: createCompletedSetViewStates(inputs: inputs))
    }
    
    public static func barLungesViewStateCompleted(inputs: [(SetInputViewState, SetModifierViewState?)],
                                                   includeHeaderLine: Bool = true) -> CompletedExerciseViewState {
        let header = SectionHeaderViewState(title: "Bar Lunges",
                                            includeLine: includeHeaderLine)
        return CompletedExerciseViewState(header: header,
                                          sets: createCompletedSetViewStates(inputs: inputs))
    }
    
    public static func benchPressViewStateCompleted(inputs: [(SetInputViewState, SetModifierViewState?)],
                                                    includeHeaderLine: Bool = true) -> CompletedExerciseViewState {
        let header = SectionHeaderViewState(title: "Bench Press",
                                            includeLine: includeHeaderLine)
        return CompletedExerciseViewState(header: header,
                                          sets: createCompletedSetViewStates(inputs: inputs))
    }
    
    public static func inclineDBRowViewStateCompleted(inputs: [(SetInputViewState, SetModifierViewState?)],
                                                      includeHeaderLine: Bool = true) -> CompletedExerciseViewState {
        let header = SectionHeaderViewState(title: "Incline Dumbbell Row",
                                            includeLine: includeHeaderLine)
        return CompletedExerciseViewState(header: header,
                                          sets: createCompletedSetViewStates(inputs: inputs))
    }
    
    public static let repsWeight3Sets: [(SetInputViewState, SetModifierViewState?)] = [
        (.repsWeight(weightTitle: lbs,
                     repsTitle: reps,
                     input: .init(weight: 135, weightPlaceholder: 100, reps: 12)),
         nil),
        (.repsWeight(weightTitle: lbs,
                     repsTitle: reps,
                     input: .init(weight: 140, reps: 10)),
         nil),
        (.repsWeight(weightTitle: lbs,
                     repsTitle: reps,
                     input: .init(weight: 155, reps: 8)),
         .dropSet(set: .repsWeight(weightTitle: lbs,
                                   repsTitle: reps,
                                   input: .init(weight: 100,
                                                repsPlaceholder: 5))))
    ]
    
    public static let repsWeight3SetsPlaceholders: [(SetInputViewState, SetModifierViewState?)] = [
        (.repsWeight(weightTitle: lbs,
                     repsTitle: reps,
                     input: .init(weightPlaceholder: 135, repsPlaceholder: 12)),
         nil),
        (.repsWeight(weightTitle: lbs,
                     repsTitle: reps,
                     input: .init(weightPlaceholder: 140, repsPlaceholder: 10)),
         nil),
        (.repsWeight(weightTitle: lbs,
                     repsTitle: reps,
                     input: .init(weightPlaceholder: 155, repsPlaceholder: 8)),
         .dropSet(set: .repsWeight(weightTitle: lbs,
                                   repsTitle: reps,
                                   input: .init(weightPlaceholder: 100,
                                                repsPlaceholder: 5))))
    ]
    
    public static let repsWeight4Sets: [(SetInputViewState, SetModifierViewState?)] = [
        (.repsWeight(weightTitle: lbs,
                     repsTitle: reps,
                     input: .init(weight: 135, weightPlaceholder: 100, reps: 12)),
         nil),
        (.repsWeight(weightTitle: lbs,
                     repsTitle: reps,
                     input: .init(weight: 140, reps: 10)),
         nil),
        (.repsWeight(weightTitle: lbs,
                     repsTitle: reps,
                     input: .init(weight: 155, reps: 8)),
         nil),
        (.repsWeight(weightTitle: lbs,
                     repsTitle: reps,
                     input: .init(weight: 225, reps: 2, repsPlaceholder: 0)),
         nil)
    ]
    
    public static let repsWeight4SetsPlaceholders: [(SetInputViewState, SetModifierViewState?)] = [
        (.repsWeight(weightTitle: lbs,
                     repsTitle: reps,
                     input: .init(weightPlaceholder: 135, repsPlaceholder: 12)),
         nil),
        (.repsWeight(weightTitle: lbs,
                     repsTitle: reps,
                     input: .init(weightPlaceholder: 140, repsPlaceholder: 10)),
         nil),
        (.repsWeight(weightTitle: lbs,
                     repsTitle: reps,
                     input: .init(weightPlaceholder: 155, repsPlaceholder: 8)),
         nil),
        (.repsWeight(weightTitle: lbs,
                     repsTitle: reps,
                     input: .init(weightPlaceholder: 225, repsPlaceholder: 2)),
         nil)
    ]
    
    public static func legWorkoutExercises(includeHeaderLine: Bool) -> [[ExerciseViewState]] {
        [
            [backSquatViewState(inputs: repsWeight4Sets, includeHeaderLine: includeHeaderLine)],
            [barLungesViewState(inputs: repsWeight3Sets, includeHeaderLine: includeHeaderLine)]
        ]
    }
    
    public static func legWorkoutExercisesPlaceholders(includeHeaderLine: Bool) -> [[ExerciseViewState]] {
        [
            [backSquatViewState(inputs: repsWeight4SetsPlaceholders, includeHeaderLine: includeHeaderLine)],
            [barLungesViewState(inputs: repsWeight3SetsPlaceholders, includeHeaderLine: includeHeaderLine)]
        ]
    }
    
    public static func legWorkoutExercisesCompleted(includeHeaderLine: Bool) -> [[CompletedExerciseViewState]] {
        [
            [backSquatViewStateCompleted(inputs: repsWeight4Sets,
                                         includeHeaderLine: includeHeaderLine)],
            [barLungesViewStateCompleted(inputs: repsWeight3Sets,
                                         includeHeaderLine: includeHeaderLine)]
        ]
    }
    
    public static func fullBodyWorkoutExercises(includeHeaderLine: Bool) -> [[ExerciseViewState]] {
        [
            [
                backSquatViewState(inputs: repsWeight3Sets, includeHeaderLine: includeHeaderLine),
                benchPressViewState(inputs: repsWeight3Sets, includeHeaderLine: includeHeaderLine)
            ],
            [
                barLungesViewState(inputs: repsWeight3Sets, includeHeaderLine: includeHeaderLine),
                inclineDBRowViewState(inputs: repsWeight3Sets, includeHeaderLine: includeHeaderLine)
            ]
        ]
    }
    
    public static func fullBodyWorkoutExercisesPlaceholders(includeHeaderLine: Bool) -> [[ExerciseViewState]] {
        [
            [
                backSquatViewState(inputs: repsWeight3SetsPlaceholders, includeHeaderLine: includeHeaderLine),
                benchPressViewState(inputs: repsWeight3SetsPlaceholders, includeHeaderLine: includeHeaderLine)
            ],
            [
                barLungesViewState(inputs: repsWeight3SetsPlaceholders, includeHeaderLine: includeHeaderLine),
                inclineDBRowViewState(inputs: repsWeight3SetsPlaceholders, includeHeaderLine: includeHeaderLine)
            ]
        ]
    }
    
    public static func fullBodyWorkoutExercisesCompleted(includeHeaderLine: Bool) -> [[CompletedExerciseViewState]] {
        [
            [
                backSquatViewStateCompleted(inputs: repsWeight3Sets,
                                            includeHeaderLine: includeHeaderLine),
                benchPressViewStateCompleted(inputs: repsWeight3Sets,
                                             includeHeaderLine: includeHeaderLine)
            ],
            [
                barLungesViewStateCompleted(inputs: repsWeight3Sets,
                                            includeHeaderLine: includeHeaderLine),
                inclineDBRowViewStateCompleted(inputs: repsWeight3Sets,
                                               includeHeaderLine: includeHeaderLine)
            ]
        ]
    }
    
    public static let emptyRepsWeightSet: SetInputViewState = .repsWeight(weightTitle: lbs, repsTitle: reps)
    
    public static let buildLegWorkoutRoutineTile: RoutineTileViewState = .init(id: ModelFixtures.legWorkoutId,
                                                                               title: ModelFixtures.legWorkoutName,
                                                                               subtitle: "2 exercises")
    
    public static let buildFullBodyWorkoutRoutineTile: RoutineTileViewState = .init(id: ModelFixtures.fullBodyWorkoutId,
                                                                                    title: ModelFixtures.fullBodyWorkoutName,
                                                                                    subtitle: "4 exercises")
    
    public static let doLegWorkoutRoutineTile: RoutineTileViewState = .init(id: ModelFixtures.legWorkoutId,
                                                                            title: ModelFixtures.legWorkoutName,
                                                                            subtitle: "2 exercises")
    
    public static let legWorkoutHistoryRoutineTile: RoutineTileViewState = .init(id: ModelFixtures.legWorkoutHistoryId,
                                                                                 title: ModelFixtures.legWorkoutName,
                                                                                 subtitle: "2 exercises")
    
    public static let doFullBodyWorkoutRoutineTile: RoutineTileViewState = .init(id: ModelFixtures.fullBodyWorkoutId,
                                                                                 title: ModelFixtures.fullBodyWorkoutName,
                                                                                 subtitle: "4 exercises",
                                                                                 lastCompletedTitle: "Last completed: Feb 3, 2023")
    
    public static let fullBodyWorkoutHistoryName = "\(ModelFixtures.fullBodyWorkoutName) | \(ModelFixtures.myPlanName)"
    
    public static let fullBodyWorkoutHistoryCompletedTitle = "Completed: Feb 3, 2023"
    
    public static let fullBodyWorkoutHistoryRoutineTile: RoutineTileViewState = .init(id: ModelFixtures.fullBodyWorkoutHistoryId,
                                                                                      title: fullBodyWorkoutHistoryName,
                                                                                      subtitle: "4 exercises",
                                                                                      lastCompletedTitle: fullBodyWorkoutHistoryCompletedTitle)
    
    public static let myPlanRoutineTile: RoutineTileViewState = .init(id: ModelFixtures.myPlanId,
                                                                      title: ModelFixtures.myPlanName,
                                                                      subtitle: "2 workouts",
                                                                      lastCompletedTitle: "Last completed: Feb 3, 2023")
}
