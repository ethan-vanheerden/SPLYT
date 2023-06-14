import SwiftUI

/// An abstract view for a FAB
struct FAB<RowContent: View>: View {
    @Binding private var isPresenting: Bool
    private let baseIcon: FABIconViewState
    private let rows: () -> RowContent
    
    init(isPresenting: Binding<Bool>,
         baseIcon: FABIconViewState,
         rows: @escaping () -> RowContent) {
        self._isPresenting = isPresenting
        self.baseIcon = baseIcon
        self.rows = rows
    }
    
    var body: some View {
        ZStack {
            Scrim()
                .edgesIgnoringSafeArea(.all)
                .isVisible(isPresenting)
                .onTapGesture {
                    withAnimation(Animation.easeOut) {
                        isPresenting.toggle()
                    }
                }
            HStack {
                Spacer()
                VStack(alignment: .trailing) {
                    Spacer()
                    rows()
                    FABIcon(viewState: baseIcon) {
                        // Adds a small vibration effect
                        let haptic = UIImpactFeedbackGenerator(style: .light)
                        haptic.impactOccurred()
                        withAnimation(Animation.easeOut) {
                            isPresenting.toggle()
                        }
                    }
                }
            }
            .padding()
        }
    }
}
