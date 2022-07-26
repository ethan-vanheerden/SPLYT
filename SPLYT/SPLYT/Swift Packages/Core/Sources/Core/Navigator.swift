import UIKit


/// A delegate to a `NavigationRouter`. This should handle the actual navigation UI changes.
public protocol Navigator: AnyObject {
    
    /// Pushes a given `UIViewController` onto the navigation stack.
    /// - Parameters:
    ///   - vc: The `UIViewController` to push
    ///   - animated: Whether or not to animate the UI change
    func push(_ vc: UIViewController, animated: Bool)
    
    /// Presents a given `UIViewController` in front of the current screen.
    /// - Parameters:
    ///   - vc: The `UIViewController` to present
    ///   - animated: Whether or not to animate the UI change
    func present(_ vc: UIViewController, animated: Bool)
    
    /// Dismisses the current view which is being shown
    /// - Parameter animated: Whether or not to animate the UI change
    func dismiss(animated: Bool)
}

/// Default methods since not every `Navigator` will need to implement each one
public extension Navigator {
    func push(_ vc: UIViewController, animated: Bool) { }
    func present(_ vc: UIViewController, animated: Bool) { }
    func dismiss(animated: Bool) { }
}

/// Default methods for base UINavigationControllers
public extension Navigator where Self: UINavigationController {
    func push(_ vc: UIViewController, animated: Bool) {
        self.pushViewController(vc, animated: animated)
    }
    
    func present(_ vc: UIViewController, animated: Bool) {
        self.present(vc, animated: animated)
    }
}
