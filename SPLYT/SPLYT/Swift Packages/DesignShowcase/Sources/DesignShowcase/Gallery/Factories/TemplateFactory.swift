import SwiftUI

struct TemplateFactory {
    @ViewBuilder
    func makeView(_ template: Template) -> some View {
        switch template {
        case .completedExerciseGroup:
            CompletedExerciseGroupViewGallery()
        case .doExerciseGroup:
            DoExerciseGroupViewGallery()
        }
    }
}
