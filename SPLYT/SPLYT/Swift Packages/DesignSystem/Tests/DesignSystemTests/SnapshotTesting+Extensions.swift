import Foundation
import SnapshotTesting
import SwiftUI

extension ViewImageConfig {
    static func smallImage() -> ViewImageConfig {
        return .init(size: CGSize(width: 200, height: 200))
    }
    
    static func mediumImage() -> ViewImageConfig {
        return .init(size: CGSize(width: 400, height: 400))
    }
    
    static func largeImage() -> ViewImageConfig {
        return .init(size: CGSize(width: 700, height: 700))
    }
}
