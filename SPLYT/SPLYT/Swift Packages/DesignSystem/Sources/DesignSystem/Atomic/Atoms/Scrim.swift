
import SwiftUI

public struct Scrim: View {
    public init() {}
    
    public var body: some View {
        ZStack {
            Text("HELLO")
            Rectangle()
                .fill(Color.white)
//                .blur(radius: 4)
                .opacity(0.5)
        }
        
    }
}

struct ScrimView_Previews: PreviewProvider {
    static var previews: some View {
        Scrim()
    }
}
