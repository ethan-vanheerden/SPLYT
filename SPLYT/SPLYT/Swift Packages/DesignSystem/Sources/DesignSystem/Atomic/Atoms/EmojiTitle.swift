import SwiftUI

public struct EmojiTitle: View {
    private let emoji: String // Assumed to be a single character emoji
    private let title: String
    
    public init(emoji: String,
                title: String) {
        self.emoji = emoji
        self.title = title
    }
    
    public var body: some View {
        VStack {
            Spacer()
            Text(emoji)
                .largeTitle()
            Text(title)
                .body(style: .semiBold)
                .multilineTextAlignment(.center)
            Spacer()
        }
    }
}
