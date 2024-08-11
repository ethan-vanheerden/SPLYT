import SwiftUI

/// Creates a SwiftUI usable version of a `SplytColor`
public extension Color {
    init(_ splytColor: SplytColor) {
        self = splytColor.color
    }
}
