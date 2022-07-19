import SwiftUI

public extension Text {
    func megaText() -> Text {
        return self.font(.largeTitle).applyWeights()
    }
    
    func titleText() -> Text {
        return self.font(.title).applyWeights()
    }
    
    func subtitleText() -> Text {
        return self.font(.title3).applyWeights()
    }
    
    func descriptionText() -> Text {
        return self.font(.subheadline).applyWeights()
    }
    
    func bodyText() -> Text {
        return self.font(.footnote).applyWeights()
    }
    
    private func applyWeights() -> Text {
        return self
            .fontWeight(.bold)
            .monospacedDigit()
    }
}
