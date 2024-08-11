import SwiftUI

public struct CollapseHeader<Content: View>: View {
    @Binding private var isExpanded: Bool
    @EnvironmentObject private var userTheme: UserTheme
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
            Image(systemName: "chevron.forward.circle")
                .rotationEffect(isExpanded ? Angle(degrees: 90) : Angle(degrees: 0))
            Text(viewState.title)
                .title2()
                .multilineTextAlignment(.center)
            Spacer()
            Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(Color(userTheme.theme))
                .imageScale(.large)
                .isVisible(viewState.isComplete ?? false)
            
        }
        .foregroundColor(Color(viewState.color ?? userTheme.theme))
        .onTapGesture {
            withAnimation {
                isExpanded.toggle()
            }
        }
    }
}

// MARK: - View State

public struct CollapseHeaderViewState: Hashable {
    public let title: String
    fileprivate let color: SplytColor?
    fileprivate let isComplete: Bool?
    
    public init(title: String,
                color: SplytColor? = nil,
                isComplete: Bool? = nil) {
        self.title = title
        self.color = color
        self.isComplete = isComplete
    }
}
