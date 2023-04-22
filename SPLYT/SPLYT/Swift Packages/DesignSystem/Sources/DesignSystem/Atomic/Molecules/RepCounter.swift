import SwiftUI

public struct RepCounter: View {
    @Binding private var selectedNumber: Int
    private let sideLength: CGFloat = Layout.size(5)
    
    public init(selectedNumber: Binding<Int>) {
        self._selectedNumber = selectedNumber
    }
    
    public var body: some View {
        HStack {
            IconButton(iconName: "minus",
                       style: .secondary,
                       iconColor: .black) {
                if selectedNumber > 0 {
                    selectedNumber -= 1
                }
            }
            Text("\(selectedNumber)")
                .body()
                .frame(width: sideLength, height: sideLength)
                .roundedBackground(cornerRadius: Layout.size(1), fill: Color(splytColor: .lightBlue))
            IconButton(iconName: "plus",
                       style: .secondary,
                       iconColor: .black) {
                selectedNumber += 1
            }
        }
    }
}
