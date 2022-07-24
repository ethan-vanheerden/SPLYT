import SwiftUI

struct MoleculeFactory {
    @ViewBuilder
    func makeView(_ molecule: Molecule) -> some View {
        switch molecule {
        case .menuItem:
            MenuItemGallery()
        case .repCounter:
            RepCounterGallery()
        }
    }
}
