
struct OrganismGallery: GalleryType {
    let title = "Organisms"
    let items: [GalleryItem] = Organism.allCases
}

enum Organism: String, CaseIterable, GalleryItem {
    case exerciseView = "Exercise View"
    case homeFAB = "Home FAB"
    case restFAB = "Rest FAB"
    
    var title: String {
        return self.rawValue
    }
}
