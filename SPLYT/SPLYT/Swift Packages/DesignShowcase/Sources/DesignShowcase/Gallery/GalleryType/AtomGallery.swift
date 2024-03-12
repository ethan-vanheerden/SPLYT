
struct AtomGallery: GalleryType {
    let title = "Atoms"
    let items: [GalleryItem] = Atom.allCases
}

enum Atom: String, CaseIterable, GalleryItem {
    case buttons = "Buttons"
    case collapseHeader = "Collapse Header"
    case emojiTitle = "Emoji Title"
    case FABIcon = "FAB Icon"
    case iconButtons = "Icon Buttons"
    case iconImage = "Icon Images"
    case progressBar = "Progress Bar"
    case scrim = "Scrim"
    case sectionHeader = "Section Header"
    case setEntry = "Set Entry"
    case settingsListItem = "Settings List Item"
    case tag = "Tag"
    case tile = "Tile"
    
    var title: String {
        return self.rawValue
    }
}
