import SwiftUI

struct AtomFactory {
    @ViewBuilder
    func makeView(_ atom: Atom) -> some View {
        switch atom {
        case .buttons:
            ButtonGallery()
        case .collapseHeader:
            CollapseHeaderGallery()
        case .FABIcon:
            FABIconGallery()
        case .iconButtons:
            IconButtonGallery()
        case .progressBar:
            ProgressBarGallery()
        case .scrim:
            ScrimGallery()
        case .sectionHeader:
            SectionHeaderGallery()
        case .setEntry:
            SetEntryGallery()
        case .stopwatchView:
            StopwatchViewGallery()
        case .tag:
            TagGallery()
        case .tile:
            TileGallery()
        }
    }
}
