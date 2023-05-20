
/// Determines the type of view shown for a particular set's input behavior.
public enum SetInputViewState: Equatable, Hashable {
    case repsWeight(weightTitle: String, repsTitle: String, input: RepsWeightInput = RepsWeightInput())
    case repsOnly(title: String, input: RepsOnlyInput = RepsOnlyInput())
    case time(title: String, input: TimeInput = TimeInput())
    
    private var getInput: any InputType {
        switch self {
        case let .repsWeight(_, _, input):
            return input
        case let .repsOnly(_, input):
            return input
        case let .time(_, input):
            return input
        }
    }
    
    public var hasPlaceholder: Bool {
        return getInput.hasPlaceholder
    }
}
