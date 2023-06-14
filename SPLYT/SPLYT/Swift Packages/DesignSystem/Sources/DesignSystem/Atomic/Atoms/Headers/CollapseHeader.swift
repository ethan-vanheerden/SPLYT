import SwiftUI

public struct CollapseHeader<Content: View>: View {
    @Binding private var isExpanded: Bool
    private let viewState: CollapseHeaderViewState
    private let content: () -> Content
    
    public init(isExpanded: Binding<Bool>,
                viewState: CollapseHeaderViewState,
                content: @escaping () -> Content) {
        self._isExpanded = isExpanded
        self.viewState = viewState
        self.content = content
    }
    
    public var body: some View {
        VStack(alignment: .leading) {
            header
            content()
                .collapsible(isExpanded: $isExpanded)
        }
    }
    
    private var header: some View {
        HStack {
            Image(systemName: "chevron.forward.circle") // TODO: 43: icon images
                .rotationEffect(isExpanded ? Angle(degrees: 90) : Angle(degrees: 0))
            Text(viewState.title)
                .title2()
                .multilineTextAlignment(.center)
            Spacer()
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(Color(splytColor: .green))
                .imageScale(.large)
                .isVisible(viewState.isComplete ?? false)
            
        }
        .foregroundColor(Color(splytColor: viewState.color))
        .onTapGesture {
            withAnimation {
                isExpanded.toggle()
            }
        }
    }
}

// MARK: - View State

public struct CollapseHeaderViewState: Equatable {
    public let title: String
    fileprivate let color: SplytColor
    fileprivate let isComplete: Bool?
    
    public init(title: String,
                color: SplytColor = .black,
                isComplete: Bool? = nil) {
        self.title = title
        self.color = color
        self.isComplete = isComplete
    }
}
