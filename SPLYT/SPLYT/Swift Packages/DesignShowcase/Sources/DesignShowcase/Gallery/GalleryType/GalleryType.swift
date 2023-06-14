import Foundation
import SwiftUI

protocol GalleryType {
    var title: String { get }
    var items: [GalleryItem] { get }
}

protocol GalleryItem {
    var title: String { get }
}

let galleryTypes: [GalleryType] = [
    ParticleGallery(),
    AtomGallery(),
    MoleculeGallery(),
    OrganismGallery(),
    TemplateGallery()
]
