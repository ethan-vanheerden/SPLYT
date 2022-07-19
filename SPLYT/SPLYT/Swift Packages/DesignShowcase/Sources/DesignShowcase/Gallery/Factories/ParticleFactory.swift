import SwiftUI

struct ParticleFactory {
    @ViewBuilder
    func makeView(_ particle: Particle) -> some View {
        switch particle {
        case .text:
            TextGallery()
        case .icons:
            IconGallery()
        }
    }
}
