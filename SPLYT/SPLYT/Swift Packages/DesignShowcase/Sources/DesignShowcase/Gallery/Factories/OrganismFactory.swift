import SwiftUI

struct OrganismFactory {
    @ViewBuilder
    func makeView(_ organism: Organism) -> some View {
        switch organism {
        case .buildExercise:
            BuildExerciseViewGallery()
        case .FAB:
            FABGallery()
        }
    }
}
