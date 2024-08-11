import SwiftUI
import DesignSystem

struct PillSegmentedControlGallery: View {
    @State private var selectionOne = 0
    private let itemsOne = ["Workouts", "Plans"]
    @State private var selectionTwo = 0
    private let itemsTwo = ["Thing 1", "Thing 2", "Thing 3", "Thing 4"]
    
    var body: some View {
        VStack {
            PillSegmentedControl(selectedIndex: $selectionOne, titles: itemsOne)
            PillSegmentedControl(selectedIndex: $selectionTwo, titles: itemsTwo)
        }
    }
}
