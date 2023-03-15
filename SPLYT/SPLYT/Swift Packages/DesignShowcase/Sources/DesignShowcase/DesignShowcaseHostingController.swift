import Foundation
import SwiftUI
import Core

final class DesignShowcaseHostingController: UIHostingController<DesignShowcaseView> {
    init() {
        let view = DesignShowcaseView()
        super.init(rootView: view)
    }
    
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
}

// MARK: - Navigator

extension DesignShowcaseHostingController: Navigator {
    public func push(_ vc: UIViewController, animated: Bool) {
        navigationController?.pushViewController(vc, animated: animated)
    }
}
