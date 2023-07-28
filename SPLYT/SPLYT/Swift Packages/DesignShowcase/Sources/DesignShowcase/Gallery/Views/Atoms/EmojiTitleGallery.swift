import SwiftUI
import DesignSystem

struct EmojiTitleGallery: View {
    
    var body: some View {
        VStack {
            EmojiTitle(emoji: "😁", title: "This is a title")
            EmojiTitle(emoji: "🫨", title: "This is another title")
                .foregroundColor(Color(splytColor: .lightBlue))
        }
    }
}
