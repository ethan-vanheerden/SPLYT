import SwiftUI

/// Triggers custom actions based on navigation events which we send.
public protocol NavigationRouter {
    associatedtype Event
    
    var navigator: Navigator? { get set}
    
    /// Performs a custom action when a navigation event is received.
    /// - Parameter event: The navigation event which should trigger some navigation
    func navigate(_ event: Event)
}

public extension NavigationRouter {
    /// Presents a UINavigationController with the starting given view.
    /// - Parameters:
    ///   - view: The root view of the UINavigationController
    ///   - navRouter: The view's navigation router
    func presentNavController<V: View, N: NavigationRouter>(view: V, navRouter: inout N) {
        // NOTE: this assigns the navigator for the given nav router
        // Use a navigation controller since we will be pushing views on top of a presented view
        let navController = UINavigationController(
            rootViewController: UIHostingController(rootView: view)
        )
        navController.setNavigationBarHidden(true, animated: false)
        navRouter.navigator = navController
        navigator?.present(navController, animated: true)
    }
}
