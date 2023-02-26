import SwiftUI

/// Creates a SwiftUI usable version of a `SplytColor`
public extension Color {
    init(splytColor: SplytColor) {
        self = splytColor.color
    }
}
