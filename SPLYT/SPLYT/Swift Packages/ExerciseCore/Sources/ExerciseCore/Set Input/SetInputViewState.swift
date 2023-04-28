
/// Determines the type of view shown for a particular set's input behavior.
public enum SetInputViewState: Equatable {
    case repsWeight(weightTitle: String, repsTitle: String, input: RepsWeightInput = RepsWeightInput())
    case repsOnly(title: String, input: RepsOnlyInput = RepsOnlyInput())
    case time(title: String, input: TimeInput = TimeInput())
}
