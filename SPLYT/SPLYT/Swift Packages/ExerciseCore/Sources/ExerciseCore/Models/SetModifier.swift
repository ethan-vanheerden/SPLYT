import Foundation

/// Different modifiers that affect a set's behavior.
///     - Drop Set: A set to failure that is performed immediately after a regular set that uses about 80% of the regular weight.
///     - Rest-Pause: A set to failure that is performed immediately after a regular set with the same weight, where you go to failure,
///         take a 5-10 sec rest, and repeat until you can't get any more reps
///     - Eccentric: Just affects the regular set by slowing down the eccentric (against gravity) part of the exercise (usually 3-5 seconds).
public enum SetModifier: Codable, Equatable {
    case dropSet(input: SetInput)
    case restPause(input: SetInput) // Will just be a reps only input
    case eccentric
    
    private enum CodingKeys: String, CodingKey {
        case dropSet = "DROP_SET"
        case restPause = "REST_PAUSE"
        case eccentric = "ECCENTRIC"
    }
    
    /// Updates this set modifier to have the new associated input. Note: no updates are made if this set modifier has no associated input.
    /// - Parameter newInput: The new input to be associated with the set modifier
    /// - Returns: The updated set modifier
    public func updateModifierInput(with newInput: SetInput?) -> SetModifier {
        guard let newInput = newInput else { return self }
        
        // We don't care about the old modifier inputs, so ignore in the switch
        switch self {
        case .dropSet:
            return .dropSet(input: newInput)
        case .restPause:
            return .restPause(input: newInput)
        default:
            return self // For modifiers with no set inputs
        }
    }
    
    public var input: SetInput? {
        switch self {
        case .dropSet(let input):
            return input
        case .restPause(let input):
            return input
        case .eccentric:
            return nil
        }
    }
}
