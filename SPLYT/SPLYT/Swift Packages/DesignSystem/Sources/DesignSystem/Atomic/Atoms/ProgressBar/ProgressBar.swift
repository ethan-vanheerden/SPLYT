import SwiftUI

public struct ProgressBar: View {
    private let viewState: ProgressBarViewState
    
    public init(viewState: ProgressBarViewState) {
        self.viewState = viewState
    }
    
    public var body: some View {
        ProgressView(value: viewState.fractionCompleted, total: 1.0)
            .progressViewStyle(ProgressBarStyle(color: viewState.color,
                                                outlineColor: viewState.outlineColor))
    }
}

// MARK: - View State

public struct ProgressBarViewState: Equatable {
    let fractionCompleted: Double // ex: .50
    let color: SplytColor
    let outlineColor: SplytColor?
    
    public init(fractionCompleted: Double,
                color: SplytColor,
                outlineColor: SplytColor? = nil) {
        self.fractionCompleted = fractionCompleted
        self.color = color
        self.outlineColor = outlineColor
    }
}
