struct MoleculeGallery: GalleryType {
    let title = "Molecules"
    let items: [GalleryItem] = Molecule.allCases
}

enum Molecule: String, CaseIterable, GalleryItem {
    case menuItem = "Menu Item"
    
    var title: String {
        return self.rawValue
    }
}
