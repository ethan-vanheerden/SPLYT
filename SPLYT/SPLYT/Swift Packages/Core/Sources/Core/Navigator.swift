import UIKit

public protocol Navigator: AnyObject {
    func push(_ vc: UIViewController, animated: Bool)
    func present(_ vc: UIViewController, animated: Bool)
    func dismiss(animated: Bool)
}

/// Default methods since not every `Navigator` will need to implement each one
public extension Navigator {
    func push(_ vc: UIViewController, animated: Bool) { }
    func present(_ vc: UIViewController, animated: Bool) { }
    func dismiss(animated: Bool) { }
}
