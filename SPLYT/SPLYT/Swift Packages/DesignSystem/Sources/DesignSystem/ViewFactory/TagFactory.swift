import Foundation
import ExerciseCore

public struct TagFactory {
    
    /// Constructs the tag used for a specific set modifier.
    /// - Parameter modifier: The set modifier to create the tag from
    /// - Returns: The `TagViewState` used to render a tag
    public static func tagFromModifier(modifier: SetModifierViewState,
                                       color: SplytColor) -> TagViewState {
        return TagViewState(title: modifier.title, color: color)
    }
}
