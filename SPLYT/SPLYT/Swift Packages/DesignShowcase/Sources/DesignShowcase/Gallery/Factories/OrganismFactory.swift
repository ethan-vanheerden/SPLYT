import SwiftUI

struct OrganismFactory {
    @ViewBuilder
    func makeView(_ organism: Organism) -> some View {
        switch organism {
        case .exerciseView:
            ExerciseViewGallery()
        case .FAB:
            FABGallery()
        }
    }
}
