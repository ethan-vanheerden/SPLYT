import SwiftUI

public struct EmojiTitle<Content: View>: View {
    private let emoji: String // Assumed to be a single character emoji
    private let title: String
    private let additionalContent: () -> Content
    
    public init(emoji: String,
                title: String,
                @ViewBuilder additionalContent: @escaping () -> Content =  { EmptyView() }) {
        self.emoji = emoji
        self.title = title
        self.additionalContent = additionalContent
    }
    
    public var body: some View {
        VStack {
            Spacer()
            Text(emoji)
                .largeTitle()
            Text(title)
                .body(style: .semiBold)
                .multilineTextAlignment(.center)
            additionalContent()
            Spacer()
        }
    }
}
