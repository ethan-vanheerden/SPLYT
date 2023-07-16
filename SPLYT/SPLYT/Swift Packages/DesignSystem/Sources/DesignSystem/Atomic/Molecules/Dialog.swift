import SwiftUI

struct Dialog<Content: View>: View {
    private let viewState: DialogViewState
    private let primaryAction: () -> Void
    private let secondaryAction: (() -> Void)?
    private let content: () -> Content
    
    init(viewState: DialogViewState,
         primaryAction: @escaping () -> Void,
         secondaryAction: (() -> Void)?,
         content: @escaping () -> Content) {
        self.viewState = viewState
        self.primaryAction = primaryAction
        self.secondaryAction = secondaryAction
        self.content = content
    }
    
    var body: some View {
        GeometryReader { proxy in
            VStack {
                Text(viewState.title)
                    .subhead()
                if let subtitle = viewState.subtitle {
                    Text(subtitle)
                        .footnote(style: .regular)
                        .multilineTextAlignment(.center)
                }
                content()
                buttons
            }
            .padding(Layout.size(2))
            .roundedBackground(cornerRadius: Layout.size(1),
                               fill: Color(splytColor: .white).shadow(.drop(radius: Layout.size(0.125))))
            .frame(width: proxy.size.width * 0.7)
            .centerGeometry(proxy: proxy)
        }
    }
    
    @ViewBuilder
    private var buttons: some View {
        if let secondaryButtonTitle = viewState.secondaryButtonTitle,
           let secondaryAction = secondaryAction {
            HStack(spacing: Layout.size(2)) {
                SplytButton(text: secondaryButtonTitle,
                            type: .secondary(color: .white),
                            textColor: .gray,
                            animationEnabled: false,
                            action: secondaryAction)
                primaryButton
            }
        } else {
            primaryButton
            .padding(.horizontal, Layout.size(5))
        }
    }
    
    @ViewBuilder
    private var primaryButton: some View {
        SplytButton(text: viewState.primaryButtonTitle,
                    type: .secondary(),
                    action: primaryAction)
    }
}

// MARK: - View State

public struct DialogViewState: Equatable {
    let title: String
    let subtitle: String?
    let primaryButtonTitle: String
    let secondaryButtonTitle: String?
    
    public init(title: String,
                subtitle: String? = nil,
                primaryButtonTitle: String,
                secondaryButtonTitle: String? = nil) {
        self.title = title
        self.subtitle = subtitle
        self.primaryButtonTitle = primaryButtonTitle
        self.secondaryButtonTitle = secondaryButtonTitle
    }
}

struct Dialog_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Dialog(viewState: DialogViewState(title: "Dialog title",
                                              primaryButtonTitle: "Ok"),
                   primaryAction: { },
                   secondaryAction: nil) {
                EmptyView()
            }
            Dialog(viewState: DialogViewState(title: "Dialog title",
                                              subtitle: "All of this text is the dialog subtitle. It can be very long.",
                                              primaryButtonTitle: "Ok"),
                   primaryAction: { },
                   secondaryAction: nil) {
                EmptyView()
            }
            Dialog(viewState: DialogViewState(title: "Dialog title",
                                              subtitle: "All of this text is the dialog subtitle. It can be very long.",
                                              primaryButtonTitle: "Ok",
                                              secondaryButtonTitle: "Cancel"),
                   primaryAction: { },
                   secondaryAction: { }) {
               Text("Additional View")
                    .body()
            }
        }
    }
}
