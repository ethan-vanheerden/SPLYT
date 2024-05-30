import Foundation
import SwiftUI

/// Inspiration from: https://www.goodrequest.com/blog/how-to-make-a-slide-to-unlock-button-in-swiftui
public struct ActionSlider: View {
    @State private var slideComplete = false
    @State private var slideWidth = Layout.size(6)
    @EnvironmentObject private var userTheme: UserTheme
    private let viewState: ActionSliderViewState
    private let finishSlideAction: () -> Void
    private let minWidth = Layout.size(6)
    private let cornerRadius = Layout.size(2)
    private let sliderHeadSize = Layout.size(5.5)
    
    public init(viewState: ActionSliderViewState,
                finishSlideAction: @escaping () -> Void) {
        self.viewState = viewState
        self.finishSlideAction = finishSlideAction
    }
    
    public var body: some View {
        GeometryReader { proxy in
            let maxWidth = proxy.size.width
            ZStack(alignment: .leading) {
                sliderBackground(maxWidth: maxWidth)
                slider(maxWidth: maxWidth)
            }
        }
        .frame(height: Layout.size(5))
    }
    
    @ViewBuilder
    private func sliderBackground(maxWidth: CGFloat) -> some View {
        let textOpacity = 1 - (1.5 * Double(slideWidth / maxWidth)) // Opaqueness descreases with slider
        ZStack {
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(Color(splytColor: viewState.sliderColor ?? userTheme.theme).opacity(0.3))
            Text(viewState.backgroundText)
                .subhead(style: .regular)
                .opacity(textOpacity < 0 ? 0 : textOpacity)
        }
    }
    
    @ViewBuilder
    private func slider(maxWidth: CGFloat) -> some View {
        ZStack(alignment: .trailing) {
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(Color(splytColor: viewState.sliderColor ?? userTheme.theme).gradient)
                .frame(width: slideWidth)
            sliderImage
        }
        .gesture(slide(maxWidth: maxWidth))
    }
    
    private func slide(maxWidth: CGFloat) -> some Gesture {
        DragGesture()
            .onChanged { newValue in
                guard !slideComplete else { return }
                if newValue.translation.width > 0 {
                    slideWidth = min(max(newValue.translation.width + minWidth, minWidth), maxWidth)
                }
            }
            .onEnded { newValue in
                guard !slideComplete else { return }
                if slideWidth < maxWidth {
                    withAnimation {
                        slideWidth = minWidth
                    }
                } else {
                    withAnimation {
                        slideComplete = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // Wait 1 second before triggering
                        finishSlideAction()
                    }
                }
            }
    }
    
    private var sliderImage: some View {
        let imageName = slideComplete ? "checkmark" : "chevron.right"
        return RoundedRectangle(cornerRadius: cornerRadius)
            .fill(Color(splytColor: .white).shadow(.drop(radius: Layout.size(0.5))))
            .frame(width: sliderHeadSize, height: sliderHeadSize)
            .overlay(
                Image(systemName: imageName)
                    .imageScale(.large)
                    .foregroundColor(Color(splytColor: .gray))
            )
    }
}

// MARK: - View State

public struct ActionSliderViewState: Equatable {
    fileprivate let sliderColor: SplytColor?
    fileprivate let backgroundText: String
    
    public init(sliderColor: SplytColor? = nil,
                backgroundText: String) {
        self.sliderColor = sliderColor
        self.backgroundText = backgroundText
    }
}
