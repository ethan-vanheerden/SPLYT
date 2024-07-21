import ExerciseCore

/// Used to transformworkout  view states into models from the view, like the opposite of a reducer.
/// This is so that our View Model does not know what the view states look like.
public struct WorkoutTransformer {
    
    public init() { }
    
    public func transformModifier(_ modifier: SetModifierViewState) -> SetModifier {
        switch modifier {
        case .dropSet(let set):
            return .dropSet(input: transformSetInput(set))
        case .restPause(let set):
            return .restPause(input: transformSetInput(set))
        case .eccentric:
            return .eccentric
        }
    }
}

// MARK: - Private

private extension WorkoutTransformer {
    func transformSetInput(_ set: SetInputViewState) -> SetInput {
        switch set {
        case let .repsWeight(_, _, input):
            return .repsWeight(input: input)
        case let .repsOnly(_, input):
            return .repsOnly(input: input)
        case let .time(_, input):
            return .time(input: input)
        }
    }
}
