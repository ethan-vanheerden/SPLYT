import SwiftUI

struct MoleculeFactory {
    @ViewBuilder
    func makeView(_ molecule: Molecule) -> some View {
        switch molecule {
        case .bottomSheet:
            BottomSheetGallery()
        case .FABRow:
            FABRowGallery()
        case .menuItem:
            MenuItemGallery()
        case .navigationBar:
            NavigationBarGallery()
        case .repCounter:
            RepCounterGallery()
        case .segmentedControl:
            SegmentedControlGallery()
        }
    }
}
