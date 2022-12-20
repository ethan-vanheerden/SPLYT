import SwiftUI

struct AtomFactory {
    @ViewBuilder
    func makeView(_ atom: Atom) -> some View {
        switch atom {
        case .sectionHeader:
            SectionHeaderGallery()
        case .FABIcon:
            FABIconGallery()
        }
    }
}
