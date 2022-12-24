import SwiftUI

struct MoleculeFactory {
    @ViewBuilder
    func makeView(_ molecule: Molecule) -> some View {
        switch molecule {
        case .FABRow:
            FABRowGallery()
        case .menuItem:
            MenuItemGallery()
        case .repCounter:
            RepCounterGallery()
        }
    }
}
