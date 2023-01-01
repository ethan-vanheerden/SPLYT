
struct MoleculeGallery: GalleryType {
    let title = "Molecules"
    let items: [GalleryItem] = Molecule.allCases
}

enum Molecule: String, CaseIterable, GalleryItem {
    case bottomSheet = "Bottom Sheet"
    case FABRow = "FAB Row"
    case menuItem = "Menu Item"
    case repCounter = "Rep Counter"
    case segmentedControl = "Segmented Control"
    
    var title: String {
        return self.rawValue
    }
}
