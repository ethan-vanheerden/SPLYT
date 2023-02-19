import SwiftUI

struct AtomFactory {
    @ViewBuilder
    func makeView(_ atom: Atom) -> some View {
        switch atom {
        case .buttons:
            ButtonGallery()
        case .FABIcon:
            FABIconGallery()
        case .scrim:
            ScrimGallery()
        case .sectionHeader:
            SectionHeaderGallery()
        case .setEntry:
            SetEntryGallery()
        case .tag:
            TagGallery()
        case .tile:
            TileGallery()
        }
    }
}
