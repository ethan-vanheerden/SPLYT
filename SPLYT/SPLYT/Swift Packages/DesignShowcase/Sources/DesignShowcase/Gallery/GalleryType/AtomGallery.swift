
struct AtomGallery: GalleryType {
    let title = "Atoms"
    let items: [GalleryItem] = Atom.allCases
}

enum Atom: String, CaseIterable, GalleryItem {
    case FABIcon = "FAB Icon"
    case scrim = "Scrim"
    case sectionHeader = "Section Header"
    case setEntry = "Set Entry"
    case tag = "Tag"
    case tile = "Tile"
    
    var title: String {
        return self.rawValue
    }
}
