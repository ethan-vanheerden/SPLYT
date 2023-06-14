import SwiftUI

struct MoleculeFactory {
    @ViewBuilder
    func makeView(_ molecule: Molecule) -> some View {
        switch molecule {
        case .actionSlider:
            ActionSliderGallery()
        case .addExerciseTile:
            AddExerciseTileGallery()
        case .bottomSheet:
            BottomSheetGallery()
        case .counter:
            CounterGallery()
        case .dialog:
            DialogGallery()
        case .homeFABRow:
            HomeFABRowGallery()
        case .menuItem:
            MenuItemGallery()
        case .navigationBar:
            NavigationBarGallery()
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
