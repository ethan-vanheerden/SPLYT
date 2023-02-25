import SwiftUI

struct Dialog<Content: View>: View {
    private let title: String
    private let subtitle: String?
    private let type: DialogType
    private let content: () -> Content
    
    init(title: String,
         subtitle: String?,
         type: DialogType,
         content: @escaping () -> Content) {
        self.title = title
        self.subtitle = subtitle
        self.type = type
        self.content = content
    }
    
    var body: some View {
        GeometryReader { proxy in
            VStack {
                Text(title)
                    .subhead()
                if let subtitle = subtitle {
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
        switch type {
        case let .singleAction(title, action):
            SplytButton(text: title,
                        size: .secondary,
                        action: action)
                .padding(.horizontal, Layout.size(5))
        case let .dualAction(primaryTitle, primaryAction, secondaryTitle, secondaryAction):
            HStack(spacing: Layout.size(2)) {
                SplytButton(text: secondaryTitle,
                            size: .secondary,
                            color: .white,
                            textColor: .gray,
                            outlineColor: .gray,
                            action: secondaryAction)
                SplytButton(text: primaryTitle,
                            size: .secondary,
                            action: primaryAction)
            }
        }
    }
}

struct Dialog_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Dialog(title: "Dialog title",
                   subtitle: "All of this text is the dialog subtitle. It can be very long.",
                   type: .singleAction(title: "Ok", action: { })) { EmptyView() }
            Dialog(title: "Dialog title no subtitle",
                   subtitle: nil,
                   type: .singleAction(title: "Ok", action: { })) { EmptyView() }
            Dialog(title: "Dialog title",
                   subtitle: "All of this text is the dialog subtitle. It can be very long.",
                   type: .dualAction(primaryTitle: "Ok", primaryAction: { }, secondaryTitle: "Cancel", secondaryAction: { })) {
                SetEntry(id: "some-entry", title: "Reps", inputType: .reps, doneAction: { _, _ in })
            }
        }
        
    }
}
