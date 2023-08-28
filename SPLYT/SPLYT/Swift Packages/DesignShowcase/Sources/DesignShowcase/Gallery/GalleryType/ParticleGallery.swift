
struct ParticleGallery: GalleryType {
    let title = "Particles"
    let items: [GalleryItem] = Particle.allCases
}

enum Particle: String, CaseIterable, GalleryItem {
    case colors = "Colors"
    case gradients = "Gradients"
    case text = "Text"
    
    var title: String {
        return self.rawValue
    }
}
