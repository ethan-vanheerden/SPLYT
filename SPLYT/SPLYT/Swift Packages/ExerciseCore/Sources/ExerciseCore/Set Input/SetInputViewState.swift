
/// Determines the type of view shown for a particular set's input behavior.
public enum SetInputViewState: Equatable {
    case repsWeight(weightTitle: String, weight: Double? = nil, repsTitle: String, reps: Int? = nil)
    case repsOnly(title: String, reps: Int? = nil)
    case time(title: String, seconds: Int? = nil)
}
