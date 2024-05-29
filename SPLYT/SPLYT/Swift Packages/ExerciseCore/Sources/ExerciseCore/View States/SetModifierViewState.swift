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
            return "Rest-Pause"
        case .eccentric:
            return "Eccentric"
        }
    }
    
    /// Dtermines if this modifier has an input which has an inputted value already.
    public var hasValue: Bool {
        switch self {
        case .dropSet(let set),
                .restPause(let set):
            return set.hasInput
        case .eccentric:
            return false
        }
    }
    
    /// Determines if this modifier has an input which has a placeholder.
    public var hasPlaceholder: Bool {
        switch self {
        case .dropSet(let set),
                .restPause(let set):
            return set.hasPlaceholder
        case .eccentric:
            return false
        }
    }
    
    /// Determines if this modifier has additional input associated with it.
    public var hasAdditionalInput: Bool {
        switch self {
        case .dropSet,
                .restPause:
            return true
        case .eccentric:
            return false
        }
    }
}
