//
//  View+ThemedConfirmationDialog.swift
//  DesignSystem
//
//  Created by Ethan Van Heerden on 10/12/24.
//

import SwiftUI

public extension View {
    
    /// Creates a SwiftUI `confirmationDialog` which is forced to have the user's dark/light appearance mode.
    /// This only exists due to a bug on the `confirmationDialog` not respecting the user's overriden appearance mode.
    /// - Parameters:
    ///   - isPresented: Whether to present the `confirmationDialog` or not
    ///   - actions: The content to put on the `confirmationDialog` (matches what you would do for a normal `confirmationDialog`
    /// - Returns: This view with the themed `confirmationDialog` conditionally applied.
    func themedConfirmationDialog<Content: View>(isPresented: Binding<Bool>,
                                                 @ViewBuilder actions: () -> Content) -> some View {
        return self
            .confirmationDialog("",
                                isPresented: isPresented,
                                titleVisibility: .hidden,
                                actions: actions)
            .introspect(.window, on: .iOS(.v16, .v17, .v18)) { window in
                window.overrideUserInterfaceStyle = AppearanceTheme.shared.mode.uiUserInterfaceStyle
            }
    }
}
