import Foundation

/// Determines the type of view shown for a set modifier
public enum SetModifierViewState: Equatable, CaseIterable, Hashable {
    case dropSet(set: SetInputViewState) // Associated type represents the actual drop set
    case restPause(set: SetInputViewState) // Associated type will be a reps only set
    case eccentric
    
    /// Need this for CaseIterable conformance when we have associated types
    public static let allCases: [SetModifierViewState] = [
        .dropSet(set: .repsWeight(weightTitle: "lbs", repsTitle: "reps")),
        .restPause(set: .repsOnly(title: "reps")),
        .eccentric
    ]
    
    public var title: String {
        switch self {
        case .dropSet:
            return "Drop Set"
        case .restPause:
            return "Rest/Pause"
        case .eccentric:
            return "Eccentric"
        }
    }
    
    public var hasPlaceholder: Bool {
        switch self {
        case .dropSet(let set),
                .restPause(let set):
            return set.hasPlaceholder
        case .eccentric:
            return false
        }
    }
}
