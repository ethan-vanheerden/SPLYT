import Foundation

/// Contains common interactor functions involving workouts.
public struct WorkoutInteractor {
    typealias Errors = WorkoutInteractorError
    
    /// Adds a set to all the exercises in an exercise group.
    /// - Parameters:
    ///   - group: The group index to add the set to (assumed to be valid)
    ///   - groups: The different exercise groups in the wokout.
    /// - Returns: The same exercise groups with the appropriate group having a set added.
    public static func addSet(group: Int, groups: [ExerciseGroup]) -> [ExerciseGroup] {
        var groups = groups
        let fromGroup = groups[group]
        var exercises = fromGroup.exercises
        
        // We want to add a set to each exercise in the group
        for (index, exercise) in fromGroup.exercises.enumerated() {
            var sets = exercise.sets
            let numSets = sets.count
            guard numSets >= 1 else { continue }
            
            // The new set should have the same input as the previous set
            let set = Set(input: sets[numSets - 1].input, // Has same input (with values) as previous set
                          modifier: nil)
            sets.append(set)
            let newExercise = Exercise(id: exercise.id,
                                       name: exercise.name,
                                       sets: sets)
            exercises[index] = newExercise
        }
        
        groups[group] = ExerciseGroup(exercises: exercises)
        
        return groups
    }
    
    /// Removes a set from all the exercises in an exercise group.
    /// - Parameters:
    ///   - group: The group index to remove the set from (assumed to be valid)
    ///   - groups: The different exercise groups in the workout
    /// - Returns: The same exercise groups with the appropriate group having a set removed
    public static func removeSet(group: Int, groups: [ExerciseGroup]) -> [ExerciseGroup] {
        var groups = groups
        let fromGroup = groups[group]
        var exercises = fromGroup.exercises
        
        // We want to remove a set from each exercise in the group
        guard exercises.count >= 1,
              // Only remove if there is > 2 sets (for now)
              exercises.first?.sets.count ?? 0 > 1 else { return groups }
        
        for (index, exercise) in fromGroup.exercises.enumerated() {
            var sets = exercise.sets
            sets.removeLast()
            let newExercise = Exercise(id: exercise.id,
                                       name: exercise.name,
                                       sets: sets)
            exercises[index] = newExercise
        }
        
        groups[group] = ExerciseGroup(exercises: exercises)
        
        return groups
    }
    
    /// Updates a set to have the new input and modifier (if present). Assumes all the indices are valid.
    /// - Parameters:
    ///   - groupIndex: The group index the set belongs to (assumed to be valid)
    ///   - groups: The different exericse groups in the workout
    ///   - exerciseIndex: The exercise index in the group the set belongs to
    ///   - setIndex: The set index in the exercise the set belongs to (assumed to be valid)
    ///   - newSetInput: The new input of the set
    ///   - newModifierInput: The new input of the set's modifier
    ///   - allowNilInput: Indicates if we should overrwrite set input values with nil.
    /// - Returns: The domain result with the updated set
    public static func updateSet(groupIndex: Int,
                                 groups: [ExerciseGroup],
                                 exerciseIndex: Int,
                                 setIndex: Int,
                                 newSetInput: SetInput?,
                                 newModifierInput: SetInput?,
                                 allowNilInput: Bool = false ) -> [ExerciseGroup] {
        let exercises = groups[groupIndex].exercises
        let targetExercise = exercises[exerciseIndex]
        
        let oldSet = targetExercise.sets[setIndex]
        let newSet = Set(input: newSetInput ?? oldSet.input,
                         modifier: oldSet.modifier?.updateModifierInput(with: newModifierInput))
        
        return replaceSet(groupIndex: groupIndex,
                          groups: groups,
                          targetExercise: targetExercise,
                          oldExercises: exercises,
                          newSet: newSet,
                          newSetIndex: setIndex,
                          exerciseIndex: exerciseIndex)
    }
    
    /// Either adds or removes a modifier into a set. Assumes all the indices are valid.
    /// - Parameters:
    ///   - groupIndex: The group index that the set belongs to
    ///   - groups: The different exericse groups in the workout
    ///   - exerciseIndex: The exercise index in the group which has the target set
    ///   - setIndex: The set index in the exercise that we want to add the modifier to
    ///   - modifier: The modifier to add or remove. If nil, we remove, else we add
    /// - Returns: An updated list of exercise groups with the appropriate modifier edited
    public static func editModifier(groupIndex: Int,
                                    groups: [ExerciseGroup],
                                    exerciseIndex: Int,
                                    setIndex: Int,
                                    modifier: SetModifier?) -> [ExerciseGroup] {
        let exercises = groups[groupIndex].exercises
        let targetExercise = exercises[exerciseIndex]
        
        let oldSet = targetExercise.sets[setIndex]
        let newSet = Set(input: oldSet.input,
                         modifier: modifier)
        
        return replaceSet(groupIndex: groupIndex,
                          groups: groups,
                          targetExercise: targetExercise,
                          oldExercises: exercises,
                          newSet: newSet,
                          newSetIndex: setIndex,
                          exerciseIndex: exerciseIndex)
    }
    
    /// Replaces an exercise in a list of groups with a target exercise. The replaced exercise will have the same
    /// number of sets as the one it's replacing.
    /// - Parameters:
    ///   - groupIndex: The group index of the target exercise to replace
    ///   - groups: The exercise groups
    ///   - exerciseIndex: The index of the exercise to replace in its respective group
    ///   - availableExercise: The `AvailableExercise` to replace an existing exercise with
    /// - Returns: The same exercise groups with the new replaced exercise
    public static func replaceExercise(groupIndex: Int,
                                       groups: [ExerciseGroup],
                                       exerciseIndex: Int,
                                       availableExercise: AvailableExercise) throws -> [ExerciseGroup] {
        var groups = groups
        
        guard groupIndex < groups.count else { throw Errors.invalidIndex }
        var targetGroup = groups[groupIndex]
        
        var exercises = targetGroup.exercises
        guard exerciseIndex < exercises.count else { throw Errors.invalidIndex }
        let targetExercise = exercises[exerciseIndex]
        
        let numSets = targetExercise.sets.count
        let exercise = createExercise(from: availableExercise,
                                      numSets: numSets)
        
        exercises[exerciseIndex] = exercise
        targetGroup.exercises = exercises
        groups[groupIndex] = targetGroup
        
        return groups
    }
    
    /// Adds the given list of `AvailableExercises` as a new group to the end of the given groups.
    /// - Parameters:
    ///   - groups: The groups to add the exercises to
    ///   - exercises: The exercises to add to the new group
    /// - Returns: The updates list of groups with the exercises added
    public static func addExercises(groups: [ExerciseGroup],
                                    exercises: [AvailableExercise]) -> [ExerciseGroup] {
        var groups = groups
        
        let exercises = exercises.map { createExercise(from: $0, numSets: 1) }
        
        groups.append(ExerciseGroup(exercises: exercises))
        
        return groups
    }
    
    
    /// Creates a unique workout/plan id using the workout/plan name and creation date
    /// in the form of: name-2023-02-15T16:39:57Z.
    /// - Parameters:
    ///   - name: The name of the workout/plan
    ///   - creationDate: The date the workout/plan was created
    /// - Returns: The id of the workout/plan
    public static func getId(name: String, creationDate: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        return name + "-" + formatter.string(from: creationDate)
    }
    
    /// Creates a new exercise with the given number of sets.
    /// - Parameters:
    ///   - available: The `AvailableExercise` that this exercise is based on
    ///   - numSets: The number of sets this exercise will have
    /// - Returns: The exercise
    public static func createExercise(from available: AvailableExercise, numSets: Int) -> Exercise {
        let id = available.id
        var sets: [Set] = []
        
        for _ in 1...numSets {
            let newSet = Set(input: available.defaultInputType,
                             modifier: nil)
            sets.append(newSet)
        }
        
        return Exercise(id: id,
                        name: available.name,
                        sets: sets)
    }
}

// MARK: - Private

private extension WorkoutInteractor {
    /// Replaces a given set in the workout.
    /// - Parameters:
    ///   - groupIndex: The group index of the set we want to replace
    ///   - groups: The different exericse groups in the workout
    ///   - targetExercise: The exercise that the set belongs to
    ///   - oldExercises: The list of exercises which includes the old set
    ///   - newSet: The new set that we want to use
    ///   - newSetIndex: The set index of the one to be replaced
    ///   - exerciseIndex: The exercise index in the group which will have the new set
    /// - Returns: An updated list of exericse groups with the updated set
    static func replaceSet(groupIndex: Int,
                           groups: [ExerciseGroup],
                           targetExercise: Exercise,
                           oldExercises: [Exercise],
                           newSet: Set,
                           newSetIndex: Int,
                           exerciseIndex: Int) -> [ExerciseGroup] {
        var groups = groups
        var newSets = targetExercise.sets
        newSets[newSetIndex] = newSet
        
        // Add the new sets to the exercise
        var newExercises = oldExercises
        let newExercise = Exercise(id: targetExercise.id,
                                   name: targetExercise.name,
                                   sets: newSets)
        newExercises[exerciseIndex] = newExercise
        
        // Replace the exercise in its group
        groups[groupIndex].exercises = newExercises
        
        return groups
    }
}

// MARK: - Errors

enum WorkoutInteractorError: Error {
    case invalidIndex
}
