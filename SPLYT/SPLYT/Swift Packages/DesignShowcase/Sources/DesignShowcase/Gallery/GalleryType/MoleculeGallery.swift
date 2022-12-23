struct MoleculeGallery: GalleryType {
    let title = "Molecules"
    let items: [GalleryItem] = Molecule.allCases
}

enum Molecule: String, CaseIterable, GalleryItem {
    case FABRow = "FAB Row"
    case menuItem = "Menu Item"
    case repCounter = "Rep Counter"
    
    var title: String {
        return self.rawValue
    }
}
