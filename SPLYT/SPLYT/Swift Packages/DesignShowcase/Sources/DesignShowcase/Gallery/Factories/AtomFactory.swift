import SwiftUI

struct AtomFactory {
    @ViewBuilder
    func makeView(_ atom: Atom) -> some View {
        switch atom {
        case .FABIcon:
            FABIconGallery()
        case .scrim:
            ScrimGallery()
        case .sectionHeader:
            SectionHeaderGallery()
        case .tile:
            TileGallery()
        }
    }
}
