import SwiftUI

struct ParticleFactory {
    @ViewBuilder
    func makeView(_ particle: Particle) -> some View {
        switch particle {
        case .colors:
            ColorGallery()
        case .gradients:
            GradientGallery()
        case .text:
            TextGallery()
        }
    }
}
