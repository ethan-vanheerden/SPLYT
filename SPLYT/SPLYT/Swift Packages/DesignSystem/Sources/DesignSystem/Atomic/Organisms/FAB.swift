
import SwiftUI

public struct FAB: View {
    @State private var isPresenting = false
    private let items: [FABRowViewState]
    
    public init(items: [FABRowViewState]) {
        self.items = items
    }
    
    // TODO: Scrim, custom alignment
    public var body: some View {
        // TODO: custom alignment
        HStack {
            Spacer()
            VStack(alignment: .trailing) {
                Spacer()
                ForEach(items) { item in
                    FABRow(viewState: item)
                }
                .isVisible(isPresenting)
                .padding(.trailing)// TODO: remove me
                FABIcon(type: plusIcon) {
                    withAnimation(Animation.easeOut) {
                        isPresenting.toggle()
                    }
                }
            }
        }
        .padding()
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
