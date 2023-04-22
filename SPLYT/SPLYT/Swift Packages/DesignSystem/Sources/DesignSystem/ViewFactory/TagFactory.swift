import Foundation
import ExerciseCore

public struct TagFactory {
    
    /// Constructs the tag used for a specific set modifer.
    /// - Parameter modifier: The set modifier to create the tag from
    /// - Returns: The `TagViewState` used to render a tag
    public static func tagFromModifier(modifier: SetModifierViewState) -> TagViewState {
        let color: SplytColor
        
        switch modifier {
        case .dropSet:
            color = .green
        case .restPause:
            color = .gray
        case .eccentric:
            color = .red
        }
        
        return TagViewState(title: modifier.title, color: color)
    }
}
