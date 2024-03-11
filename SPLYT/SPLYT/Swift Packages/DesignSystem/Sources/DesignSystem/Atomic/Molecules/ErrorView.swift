import Foundation
import SwiftUI

public struct ErrorView: View {
    private let retryAction: (() -> Void)?
    private let backAction: (() -> Void)?
    
    public init(retryAction: (() -> Void)? = nil,
                backAction: (() -> Void)? = nil) {
        self.retryAction = retryAction
        self.backAction = backAction
    }
    
    public var body: some View {
        EmojiTitle(emoji: "⚠️",
                   title: Strings.errorMessage) {
            buttons
        }
                   .padding(.horizontal, Layout.size(4))
    }
    
    @ViewBuilder
    private var buttons: some View {
        VStack {
            if let retryAction = retryAction {
                SplytButton(text: Strings.retry, action: retryAction)
            }
            if let backAction = backAction {
                SplytButton(text: Strings.exit, action: backAction)
            }
        }
        .padding(.top, Layout.size(1))
    }
}

fileprivate struct Strings {
    static let errorMessage = "Uh oh, something went wrong. Please try again later."
    static let retry = "Retry"
    static let exit = "Exit"
}
