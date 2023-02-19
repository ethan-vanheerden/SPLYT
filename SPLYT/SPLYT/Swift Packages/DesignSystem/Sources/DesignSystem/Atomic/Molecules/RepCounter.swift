import SwiftUI

public struct RepCounter: View {
    @Binding private var selectedNumber: Int
    private let sideLength: CGFloat = Layout.size(5)
    
    public init(selectedNumber: Binding<Int>) {
        self._selectedNumber = selectedNumber
    }
    
    public var body: some View {
        HStack {
            Button { // TODO: 36: icon buttons
                if selectedNumber > 0 {
                    selectedNumber -= 1
                }
            } label: {
                Image(systemName: "minus")
            }
            .tint(.black)
            Text("\(selectedNumber)")
                .body()
                .frame(width: sideLength, height: sideLength)
                .roundedBackground(cornerRadius: Layout.size(1), fill: Color.splytColor(.lightBlue))
            Button {
                selectedNumber += 1
            } label: {
                Image(systemName: "plus")
            }
            .tint(.black)
        }
    }
}
