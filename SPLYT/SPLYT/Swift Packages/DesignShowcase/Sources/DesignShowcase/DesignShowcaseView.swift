import SwiftUI
import DesignSystem

struct DesignShowcaseView: View {
    var body: some View {
        List(galleryTypes, id: \.title) { type in
            NavigationLink(type.title) {
                detail(items: type.items)
                    .navigationTitle(type.title)
            }
        }
    }
    
    @ViewBuilder
    private func detail(items: [GalleryItem]) -> some View {
        List(items, id: \.title) { item in
            NavigationLink(item.title) {
                switch item {
                case let particle as Particle:
                    ParticleFactory().makeView(particle)
                case let atom as Atom:
                    AtomFactory().makeView(atom)
                case let molecule as Molecule:
                    MoleculeFactory().makeView(molecule)
                case let organism as Organism:
                    OrganismFactory().makeView(organism)
                case let template as Template:
                    TemplateFactory().makeView(template)
                default:
                    EmptyView()
                }
            }
        }
    }
}
