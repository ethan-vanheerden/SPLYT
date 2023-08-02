
struct OrganismGallery: GalleryType {
    let title = "Organisms"
    let items: [GalleryItem] = Organism.allCases
}

enum Organism: String, CaseIterable, GalleryItem {
    case completedExerciseView = "Completed Exercise View"
    case exerciseView = "Exercise View"
    case homeFAB = "Home FAB"
    case restFAB = "Rest FAB"
    case restPicker = "Rest Picker"
    
    var title: String {
        return self.rawValue
    }
}
