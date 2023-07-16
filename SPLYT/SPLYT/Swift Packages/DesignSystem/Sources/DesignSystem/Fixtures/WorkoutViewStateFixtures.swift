@testable import ExerciseCore

// TODO: this needs to be moved to the test target but xcode is broken
/// Contains test view states for things related to workouts.
struct WorkoutViewStateFixtures {
    typealias ModelFixtures = WorkoutModelFixtures
    
    static let reps = "reps"
    
    static let lbs = "lbs"
    
    static let sec = "sec"
    
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
    
    static func backSquatViewState(inputs: [(SetInputViewState, SetModifierViewState?)],
                                   includeHeaderLine: Bool = true) -> ExerciseViewState {
        let header = SectionHeaderViewState(title: "Back Squat",
                                            includeLine: includeHeaderLine)
        return ExerciseViewState(header: header,
                                 sets: createSetViewStates(inputs: inputs),
                                 canRemoveSet: inputs.count > 1)
    }
    
    static func barLungesViewState(inputs: [(SetInputViewState, SetModifierViewState?)],
                                   includeHeaderLine: Bool = true) -> ExerciseViewState {
        let header = SectionHeaderViewState(title: "Bar Lunges",
                                            includeLine: includeHeaderLine)
        return ExerciseViewState(header: header,
                                 sets: createSetViewStates(inputs: inputs),
                                 canRemoveSet: inputs.count > 1)
    }
    
    static func benchPressViewState(inputs: [(SetInputViewState, SetModifierViewState?)],
                                    includeHeaderLine: Bool = true) -> ExerciseViewState {
        let header = SectionHeaderViewState(title: "Bench Press",
                                            includeLine: includeHeaderLine)
        return ExerciseViewState(header: header,
                                 sets: createSetViewStates(inputs: inputs),
                                 canRemoveSet: inputs.count > 1)
    }
    
    static func inclineDBRowViewState(inputs: [(SetInputViewState, SetModifierViewState?)],
                                      includeHeaderLine: Bool = true) -> ExerciseViewState {
        let header = SectionHeaderViewState(title: "Incline Dumbbell Row",
                                            includeLine: includeHeaderLine)
        return ExerciseViewState(header: header,
                                 sets: createSetViewStates(inputs: inputs),
                                 canRemoveSet: inputs.count > 1)
    }
    
    static let repsWeight3Sets: [(SetInputViewState, SetModifierViewState?)] = [
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
    
    static let repsWeight3SetsPlaceholders: [(SetInputViewState, SetModifierViewState?)] = [
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
    
    static let repsWeight4Sets: [(SetInputViewState, SetModifierViewState?)] = [
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
    
    static let repsWeight4SetsPlaceholders: [(SetInputViewState, SetModifierViewState?)] = [
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
    
    static func legWorkoutExercises(includeHeaderLine: Bool) -> [[ExerciseViewState]] {
        [
            [backSquatViewState(inputs: repsWeight4Sets, includeHeaderLine: includeHeaderLine)],
            [barLungesViewState(inputs: repsWeight3Sets, includeHeaderLine: includeHeaderLine)]
        ]
    }
    
    static func legWorkoutExercisesPlaceholders(includeHeaderLine: Bool) -> [[ExerciseViewState]] {
        [
            [backSquatViewState(inputs: repsWeight4SetsPlaceholders, includeHeaderLine: includeHeaderLine)],
            [barLungesViewState(inputs: repsWeight3SetsPlaceholders, includeHeaderLine: includeHeaderLine)]
        ]
    }
    
    static func fullBodyWorkoutExercises(includeHeaderLine: Bool) -> [[ExerciseViewState]] {
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
    
    static func fullBodyWorkoutExercisesPlaceholders(includeHeaderLine: Bool) -> [[ExerciseViewState]] {
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
    
    static let emptyRepsWeightSet: SetInputViewState = .repsWeight(weightTitle: lbs, repsTitle: reps)
    
    static let buildLegWorkoutRoutineTile: RoutineTileViewState = .init(id: ModelFixtures.legWorkoutId,
                                                                        title: ModelFixtures.legWorkoutName,
                                                                        subtitle: "2 exercises")
    
    static let buildFullBodyWorkoutRoutineTile: RoutineTileViewState = .init(id: ModelFixtures.fullBodyWorkoutId,
                                                                             title: ModelFixtures.fullBodyWorkoutName,
                                                                             subtitle: "4 exercises")
    
    static let doLegWorkoutRoutineTile: RoutineTileViewState = .init(id: ModelFixtures.legWorkoutId,
                                                                     historyFilename: ModelFixtures.legWorkoutFilename,
                                                                     title: ModelFixtures.legWorkoutName,
                                                                     subtitle: "2 exercises")
    
    static let doFullBodyWorkoutRoutineTile: RoutineTileViewState = .init(id: ModelFixtures.fullBodyWorkoutId,
                                                                          historyFilename: ModelFixtures.fullBodyWorkoutFilename,
                                                                          title: ModelFixtures.fullBodyWorkoutName,
                                                                          subtitle: "4 exercises",
                                                                          lastCompletedTitle: "Last completed: Feb 3, 2023")
    
    static let myPlanRoutineTile: RoutineTileViewState = .init(id: ModelFixtures.myPlanId,
                                                               title: ModelFixtures.myPlanName,
                                                               subtitle: "2 workouts",
                                                               lastCompletedTitle: "Last completed: Feb 3, 2023")
}
