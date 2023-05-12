import SwiftUI

struct MoleculeFactory {
    @ViewBuilder
    func makeView(_ molecule: Molecule) -> some View {
        switch molecule {
        case .addExerciseTile:
            AddExerciseTileGallery()
        case .bottomSheet:
            BottomSheetGallery()
        case .dialog:
            DialogGallery()
        case .homeFABRow:
            HomeFABRowGallery()
        case .menuItem:
            MenuItemGallery()
        case .navigationBar:
            NavigationBarGallery()
        case .repCounter:
            RepCounterGallery()
        case .restFABRow:
            RestFABRowGallery()
        case .segmentedControl:
            SegmentedControlGallery()
        case .setView:
            SetViewGallery()
        case .tabBar:
            TabBarGallery()
        }
    }
}
