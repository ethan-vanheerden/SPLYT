import Foundation
import ExerciseCore

/// Contains common reducer functions involving workouts.
public struct WorkoutReducer {
    
    public static func reduceExerciseGroups(groups: [ExerciseGroup],
                                            includeHeaderLine: Bool = true) -> [[ExerciseViewState]] {
        var result = [[ExerciseViewState]]()
        
        for group in groups {
            // For each group, get the ExerciseViewStates of the exercises in it
            let exercises = getExerciseViewStates(exercises: group.exercises,
                                                  includeHeaderLine: includeHeaderLine)
            result.append(exercises)
        }
        
        return result
    }
    
    /// Ex: ["Group 1", "Group 2", "Group 3"]
    public static func getGroupTitles(workout: Workout) -> [String] {
        var titles = [String]()
        
        // We can assume that there is always at least one group
        for i in 1...workout.exerciseGroups.count {
            titles.append(Strings.group + " \(i)")
        }
        
        return titles
    }
    
    
    /// Returns a string representation of the number of exercises in the given workout.
    /// - Parameter workout: The workout to get the number of exercises from
    /// - Returns: A title describing the number of exercises, ex: "5 exercises"
    public static func getNumExercisesTitle(workout: Workout) -> String {
        var numExercises = 0
        for group in workout.exerciseGroups {
            numExercises += group.exercises.count
        }
        let exercisePlural = numExercises == 1 ? Strings.exercise : Strings.exercises
        return "\(numExercises) \(exercisePlural)"
    }
    
    /// Returns a string representation of the number of workouts in the given plan.
    /// - Parameter plan: The plan to get the number of exercises from
    /// - Returns: A title describing the number of workouts, ex: "4 workouts"
    public static func getNumWorkoutsTitle(plan: Plan) -> String {
        let numWorkouts = plan.workouts.count
        let workoutsPlural = numWorkouts == 1 ? Strings.workout : Strings.workouts
        
        return "\(numWorkouts) \(workoutsPlural)"
    }
}

// MARK: - Private

private extension WorkoutReducer {
    
    static func getExerciseViewStates(exercises: [Exercise], includeHeaderLine: Bool) -> [ExerciseViewState] {
        return exercises.map { exercise in
            let headerState = SectionHeaderViewState(title: exercise.name,
                                                     includeLine: includeHeaderLine)
            return ExerciseViewState(header: headerState,
                                     sets: getSetStates(exercise: exercise),
                                     canRemoveSet: exercise.sets.count > 1)
        }
    }
    
    static func getSetStates(exercise: Exercise) -> [SetViewState] {
        return exercise.sets.enumerated().map { index, set in
            SetViewState(setIndex: index,
                         title: Strings.set + " \(index + 1)",
                         type: getSetViewType(set.input),
                         modifier: getSetModifierState(modifier: set.modifier))
        }
    }
    
    static func getSetViewType(_ input: SetInput) -> SetInputViewState {
        switch input {
        case let .repsWeight(input):
            return .repsWeight(weightTitle: Strings.lbs,
                               repsTitle: Strings.reps,
                               input: input)
        case let .repsOnly(input):
            return .repsOnly(title: Strings.reps, input: input)
        case let .time(input):
            return .time(title: Strings.sec, input: input)
        }
    }
    
    static func getSetModifierState(modifier: SetModifier?) -> SetModifierViewState? {
        guard let modifier = modifier else { return nil }
        
        switch modifier {
        case .dropSet(let input):
            return .dropSet(set: getSetViewType(input))
        case .restPause(let input):
            return .restPause(set: getSetViewType(input))
        case .eccentric:
            return .eccentric
        }
    }
}

// MARK: - Strings

fileprivate struct Strings {
    static let set = "Set"
    static let lbs = "lbs"
    static let reps = "reps"
    static let sec = "sec"
    static let group = "Group"
    static let exercise = "exercise"
    static let exercises = "exercises"
    static let workout = "workout"
    static let workouts = "workouts"
}
