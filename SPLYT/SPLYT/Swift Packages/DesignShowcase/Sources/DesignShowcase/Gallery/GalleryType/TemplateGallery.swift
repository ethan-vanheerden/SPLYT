
struct TemplateGallery: GalleryType {
    let title = "Templates"
    let items: [GalleryItem] = Template.allCases
}

enum Template: String, CaseIterable, GalleryItem {
    case doExerciseGroup = "Do Exercise Group"
    
    var title: String {
        return self.rawValue
    }
}
