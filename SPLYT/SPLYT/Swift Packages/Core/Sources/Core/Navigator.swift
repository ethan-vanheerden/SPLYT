import UIKit
import SwiftUI

/// A delegate to a `NavigationRouter`. This should handle the actual navigation UI changes.
public protocol Navigator: AnyObject {
    
    /// Pushes a given `UIViewController` onto the navigation stack.
    /// - Parameters:
    ///   - vc: The `UIViewController` to push
    ///   - animated: Whether or not to animate the UI change
    func push(_ vc: UIViewController, animated: Bool)
    
    /// Pushes a given SwiftUI `View` onto the navigation stack.
    /// - Parameters:
    ///   - view: The `View` to push
    ///   - animated: Whether or not to animate the UI change
    func push<Content: View>(_ view: Content, animated: Bool)
    
    /// Presents a given `UIViewController` in front of the current screen.
    /// - Parameters:
    ///   - vc: The `UIViewController` to present
    ///   - animated: Whether or not to animate the UI change
    func present(_ vc: UIViewController, animated: Bool)
    
    /// Presents a given SwiftUI `View` in front of the current screen.
    /// - Parameters:
    ///   - view: The `View` to present
    ///   - animated: Whether or not to animate the UI change
    func present<Content: View>(_ view: Content, animated: Bool)
    
    /// Dismisses the current view which is being shown
    /// - Parameter animated: Whether or not to animate the UI change
    func dismiss(animated: Bool)
    
    /// Dismisses all of the views that this Navigator handles.
    /// - Parameter animated: Whether or not to animate the UI change
    func dismissSelf(animated: Bool)
    
    func dismissWithCompletion(animated: Bool, completion: @escaping () -> Void)
    
    /// Pops the top view controller on the current navigation stack.
    /// - Parameter animated: Whether or not to animate the UI change
    func pop(animated: Bool)
}

/// Default methods for base UINavigationControllers
public extension Navigator where Self: UINavigationController {
    func push(_ vc: UIViewController, animated: Bool) {
        self.pushViewController(vc, animated: animated)
    }
    
    func present(_ vc: UIViewController, animated: Bool) {
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: animated)
    }
    
    func dismiss(animated: Bool) {
        self.dismiss(animated: animated)
    }
    
   func dismissSelf(animated: Bool) {
       self.presentationController?.presentingViewController.dismiss(animated: animated)
    }
    
    func dismissWithCompletion(animated: Bool, completion: @escaping () -> Void) {
        self.dismiss(animated: animated, completion: completion)
    }
    
    func pop(animated: Bool) {
        self.popViewController(animated: animated)
    }
}
