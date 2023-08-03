import SwiftUI

struct OrganismFactory {
    @ViewBuilder
    func makeView(_ organism: Organism) -> some View {
        switch organism {
        case .completedExerciseView:
            CompletedExerciseViewGallery()
        case .exerciseView:
            ExerciseViewGallery()
        case .homeFAB:
            HomeFABGallery()
        case .restFAB:
            RestFABGallery()
        case .restPicker:
            RestPickerGallery()
        }
    }
}
