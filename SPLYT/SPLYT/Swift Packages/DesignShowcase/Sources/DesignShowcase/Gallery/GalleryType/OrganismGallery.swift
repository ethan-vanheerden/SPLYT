
struct OrganismGallery: GalleryType {
    let title = "Organisms"
    let items: [GalleryItem] = Organism.allCases
}

enum Organism: String, CaseIterable, GalleryItem {
    case FAB = "FAB"
    
    var title: String {
        return self.rawValue
    }
}
