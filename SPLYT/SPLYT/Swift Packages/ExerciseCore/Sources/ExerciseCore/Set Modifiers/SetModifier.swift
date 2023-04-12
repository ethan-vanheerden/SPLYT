import Foundation

/// Different modifiers that affect a set's behavior.
///     - Drop Set: A set to failure that is performed immediately after a regular set that uses about 80% of the regular weight.
///     - Rest/Pause: A set to failure that is performed immediately after a regular set with the same weight, where you go to failure,
///         take a 5-10 sec rest, and repeat until you can't get any more reps
///     - Eccentric: Just affects the regular set by slowing down the eccentric (against gravity) part of the exercise (usually 3-5 seconds).
public enum SetModifier: Codable, Equatable {
    case dropSet(input: SetInput)
    case restPause(reps: Int)
    case eccentric
    
    private enum CodingKeys: String, CodingKey {
        case dropSet = "DROP_SET"
        case restPause = "REST_PAUSE"
        case eccentric = "ECCENTRIC"
    }
}
