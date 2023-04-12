import Foundation

public struct SetModifierViewState: Equatable {
    public let id: AnyHashable
    public let type: SetModifierViewType
    
    public init(id: AnyHashable,
                type: SetModifierViewType) {
        self.id = id
        self.type = type
    }
}

// MARK: - Modifier View Type

/// Determines the type of view shown for a set modifier
public enum SetModifierViewType: Equatable, CaseIterable {
    case dropSet(set: SetInputViewState) // Associated type represents the actual drop set
    case restPause(set: SetInputViewState) // Associated type will be a reps only set
    case eccentric
    
    /// Need this for CaseIterable conformance when we have associated types
    public static let allCases: [SetModifierViewType] = [
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
}
