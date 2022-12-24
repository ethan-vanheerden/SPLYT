
import SwiftUI

public struct FAB: View {
    @State private var isPresenting = false
    private let items: [FABRowViewState]
    
    public init(items: [FABRowViewState]) {
        self.items = items
    }
    
    /// Initializer for testing purposes
    init(items: [FABRowViewState],
         isPresentingOverride: Bool) {
        self.items = items
        self._isPresenting = State(initialValue: isPresentingOverride)
    }
    
    public var body: some View {
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
                    ForEach(items, id: \.id) { item in
                        FABRow(viewState: item)
                    }
                    .isVisible(isPresenting)
                    .padding(.trailing, Layout.size(2))
                    FABIcon(type: plusIcon) {
                        withAnimation(Animation.easeOut) {
                            isPresenting.toggle()
                        }
                    }
                }
            }
            .padding()
        }
    }
    
    private var plusIcon: FABIconType {
        return FABIconType(size: .primary, imageName: "plus")
    }
}



struct FAB_Previews: PreviewProvider {
    static var previews: some View {
        FAB(items: [
            FABRowViewState(title: "CREATE NEW PLAN",
                            imageName: "calendar",
                            tapAction: { }),
            FABRowViewState(title: "CREATE NEW WORKOUT",
                            imageName: "figure.strengthtraining.traditional",
                            tapAction: { })
        ])
    }
}
