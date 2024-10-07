//
//  Navigator+Extensions.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 8/24/24.
//

import SwiftUI
import Core

extension Navigator where Self: UINavigationController {
    public func push<Content: View>(_ view: Content, animated: Bool) {
        let hostingController = ThemedHostingController(rootView: view.withUserTheme())
        push(hostingController, animated: animated)
    }
    
    public func present<Content: View>(_ view: Content, animated: Bool) {
        let hostingController = ThemedHostingController(rootView: view.withUserTheme())
        hostingController.modalPresentationStyle = .fullScreen
        present(hostingController, animated: animated)
    }
}

extension UINavigationController: @retroactive Navigator { }

// TODO: SwiftUI stuff not respecting dark mode - sheets/action buttons
