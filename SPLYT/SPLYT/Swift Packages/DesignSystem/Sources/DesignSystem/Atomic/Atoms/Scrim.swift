
import SwiftUI

public struct Scrim: View {
    public init() {}
    
    public var body: some View {
        Rectangle()
            .fill(.ultraThinMaterial)
            .opacity(0.95)
    }
}

struct ScrimView_Previews: PreviewProvider {
    static var previews: some View {
        Scrim()
    }
}
