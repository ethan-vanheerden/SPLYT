//
//  NavigationRouter+Extensions.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 8/24/24.
//

import Core
import SwiftUI
import DesignSystem

extension NavigationRouter {
    /// Presents a UINavigationController with the starting given view.
    /// - Parameters:
    ///   - view: The root view of the UINavigationController
    ///   - navRouter: The view's navigation router
    func presentNavController<V: View, N: NavigationRouter>(view: V, navRouter: inout N) {
        // NOTE: this assigns the navigator for the given nav router
        // Use a navigation controller since we will be pushing views on top of a presented view
        let navController = ThemedNavigationController(
            rootViewController: ThemedHostingController(rootView: view)
        )
        navController.setNavigationBarHidden(true, animated: false)
        navRouter.navigator = navController
        navigator?.present(navController, animated: true)
    }
}
