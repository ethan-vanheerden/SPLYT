import Core
import UIKit

public final class MockNavigator: Navigator {
    public init() { }
    
    public private(set) var stubPushedVC: UIViewController?
    public func push(_ vc: UIViewController, animated: Bool) {
        stubPushedVC = vc
    }
    
    public private(set) var stubPresentedVC: UIViewController?
    public func present(_ vc: UIViewController, animated: Bool) {
        stubPresentedVC = vc
    }
    
    public private(set) var calledDismiss = false
    public func dismiss(animated: Bool) {
        calledDismiss = true
    }
    
    public private(set) var calledDismissSelf = false
    public func dismissSelf(animated: Bool) {
        calledDismissSelf = true
    }
    
    public func dismissWithCompletion(animated: Bool, completion: @escaping () -> Void) {
        
    }
    
    public private(set) var calledPop = false
    public func pop(animated: Bool) {
        calledPop = true
    }
}
