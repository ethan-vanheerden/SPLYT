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
        case .completedSetView:
            CompletedSetViewGallery()
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
        case .routineTile:
            RoutineTileGallery()
        case .segmentedControl:
            SegmentedControlGallery()
        case .setView:
            SetViewGallery()
        case .tabBar:
            TabBarGallery()
        case .textEntry:
            TextEntryGallery()
        }
    }
}
