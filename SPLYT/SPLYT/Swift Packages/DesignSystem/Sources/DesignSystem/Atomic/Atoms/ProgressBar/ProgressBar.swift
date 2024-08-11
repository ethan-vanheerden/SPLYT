import SwiftUI

public struct ProgressBar: View {
    private let viewState: ProgressBarViewState
    
    public init(viewState: ProgressBarViewState) {
        self.viewState = viewState
    }
    
    public var body: some View {
        ProgressView(value: viewState.fractionCompleted, total: 1.0)
            .progressViewStyle(ProgressBarStyle(color: viewState.color))
    }
}

// MARK: - View State

public struct ProgressBarViewState: Equatable {
    let fractionCompleted: Double // ex: .50
    let color: SplytColor?
    
    public init(fractionCompleted: Double,
                color: SplytColor? = nil) {
        self.fractionCompleted = fractionCompleted
        self.color = color
    }
}
