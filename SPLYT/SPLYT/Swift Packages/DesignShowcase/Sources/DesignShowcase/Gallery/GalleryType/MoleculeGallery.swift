
struct MoleculeGallery: GalleryType {
    let title = "Molecules"
    let items: [GalleryItem] = Molecule.allCases
}

enum Molecule: String, CaseIterable, GalleryItem {
    case actionSlider = "Action Slider"
    case addExerciseTile = "Add Exercise Tile"
    case bottomSheet = "Bottom Sheet"
    case completedSetView = "Completed Set View"
    case counter = "Counter"
    case dialog = "Dialog"
    case homeFABRow = "Home FAB Row"
    case menuItem = "Menu Item"
    case navigationBar = "Navigation Bar"
    case restFABRow = "Rest FAB Row"
    case routineTile = "Routine Tile"
    case segmentedControl = "Segmented Control"
    case setView = "Set View"
    case tabBar = "Tab Bar"
    case textEntry = "Text Entry"
    
    var title: String {
        return self.rawValue
    }
}
