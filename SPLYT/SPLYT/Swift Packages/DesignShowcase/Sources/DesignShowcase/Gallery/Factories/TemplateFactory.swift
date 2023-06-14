import SwiftUI

struct TemplateFactory {
    @ViewBuilder
    func makeView(_ template: Template) -> some View {
        switch template {
        case .doExerciseGroup:
            DoExerciseGroupViewGallery()
        }
    }
}
