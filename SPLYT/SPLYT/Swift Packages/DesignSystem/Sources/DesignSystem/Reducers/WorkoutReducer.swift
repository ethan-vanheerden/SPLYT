import Foundation
import ExerciseCore

public struct WorkoutReducer {
    public init() { }
    
    public func reduceExerciseGroups(groups: [ExerciseGroup],
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
    public func getGroupTitles(workout: Workout) -> [String] {
        var titles = [String]()
        
        // We can assume that there is always at least one group
        for i in 1...workout.exerciseGroups.count {
            titles.append(Strings.group + " \(i)")
        }
        
        return titles
    }
}

// MARK: - Private

private extension WorkoutReducer {
    
    func getExerciseViewStates(exercises: [Exercise], includeHeaderLine: Bool) -> [ExerciseViewState] {
        return exercises.map { exercise in
            let headerState = SectionHeaderViewState(title: exercise.name,
                                                     includeLine: includeHeaderLine)
            return ExerciseViewState(header: headerState,
                                          sets: getSetStates(exercise: exercise),
                                          canRemoveSet: exercise.sets.count > 1)
        }
    }
    
    func getSetStates(exercise: Exercise) -> [SetViewState] {
        return exercise.sets.enumerated().map { index, set in
            SetViewState(setIndex: index,
                         title: Strings.set + " \(index + 1)",
                         type: getSetViewType(set.input),
                         modifier: getSetModifierState(modifier: set.modifier))
        }
    }
    
    func getSetViewType(_ input: SetInput) -> SetInputViewState {
        switch input {
        case let .repsWeight(input: input):
            return .repsWeight(weightTitle: Strings.lbs,
                               repsTitle: Strings.reps,
                               input: input)
        case let .repsOnly(input: input):
            return .repsOnly(title: Strings.reps, input: input)
        case let .time(input):
            return .time(title: Strings.sec, input: input)
        }
    }
    
    func getSetModifierState(modifier: SetModifier?) -> SetModifierViewState? {
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
}
