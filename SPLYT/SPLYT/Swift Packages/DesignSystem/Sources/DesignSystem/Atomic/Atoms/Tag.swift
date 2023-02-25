import SwiftUI

public struct Tag<S: ShapeStyle>: View {
    private let text: String
    private let fill: S
    
    public init(text: String,
                fill: S) {
        self.text = text
        self.fill = fill
    }
    
    public var body: some View {
        Text(text)
            .footnote()
            .padding(Layout.size(0.5))
            .foregroundColor(.white)
            .roundedBackground(cornerRadius: Layout.size(0.5),
                               fill: fill.shadow(.drop(radius: Layout.size(0.5))))
    }
}

// MARK: Set Tags

public enum SetTag {
    case dropSet
    case restPause
    case eccentric
    
    @ViewBuilder
    var tag: some View {
        switch self {
        case .dropSet:
            Tag(text: "dropset", fill: Color(splytColor: .red))
        case .restPause:
            Tag(text: "rest/pause", fill: Color(splytColor: .green))
        case .eccentric:
            Tag(text: "eccentric", fill: Color(splytColor: .gray))
        }
    }
}
