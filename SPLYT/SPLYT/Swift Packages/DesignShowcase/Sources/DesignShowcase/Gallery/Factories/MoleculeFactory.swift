import SwiftUI

struct MoleculeFactory {
    @ViewBuilder
    func makeView(_ molecule: Molecule) -> some View {
        switch molecule {
        case .addExerciseTile:
            AddExerciseTileGallery()
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
        case .setView:
            SetViewGallery()
        }
    }
}
