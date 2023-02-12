
struct MoleculeGallery: GalleryType {
    let title = "Molecules"
    let items: [GalleryItem] = Molecule.allCases
}

enum Molecule: String, CaseIterable, GalleryItem {
    case addExerciseTile = "Add Exercise Tile"
    case bottomSheet = "Bottom Sheet"
    case FABRow = "FAB Row"
    case menuItem = "Menu Item"
    case navigationBar = "Navigation Bar"
    case repCounter = "Rep Counter"
    case segmentedControl = "Segmented Control"
    case setView = "Set View"
    
    var title: String {
        return self.rawValue
    }
}
