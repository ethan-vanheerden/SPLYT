import SwiftUI
import DesignSystem

struct SegmentedControlGallery: View {
    @State private var selectionOne = 0
    private let itemsOne = ["GROUP 1", "GROUP 2", "GROUP 3"]
    @State private var selectionTwo = 0
    private let itemsTwo = ["GROUP 1", "GROUP 2", "GROUP 3", "GROUP 4", "GROUP 5"]
    
    var body: some View {
        VStack {
            SegmentedControl(selectedIndex: $selectionOne, titles: itemsOne)
            SegmentedControl(selectedIndex: $selectionTwo, titles: itemsTwo)
        }
    }
}
