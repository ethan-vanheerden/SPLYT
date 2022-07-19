struct AtomGallery: GalleryType {
    let title = "Atoms"
    let items: [GalleryItem] = Atom.allCases
}

enum Atom: String, CaseIterable, GalleryItem {
    case sectionHeader = "Section Header"
    
    var title: String {
        return self.rawValue
    }
}
