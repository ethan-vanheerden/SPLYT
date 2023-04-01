
import SwiftUI

public struct Scrim: View {
    public init() {}
    
    public var body: some View {
        Color(splytColor: .gray).opacity(0.15)
    }
}

struct ScrimView_Previews: PreviewProvider {
    static var previews: some View {
        Scrim()
    }
}
