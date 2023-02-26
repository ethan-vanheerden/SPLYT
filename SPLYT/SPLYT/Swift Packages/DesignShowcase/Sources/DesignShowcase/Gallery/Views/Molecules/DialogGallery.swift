
import SwiftUI
import DesignSystem

struct DialogGallery: View {
    @State private var dialogOneOpen = false
    @State private var dialogTwoOpen = false
    @State private var dialogThreeOpen = false
    private let viewStateOne = DialogViewState(title: "Dialog 1",
                                               primaryButtonTitle: "Ok")
    private let viewStateTwo = DialogViewState(title: "Dialog 2",
                                               subtitle: "All of this text is the dialog subtitle. It can be very long.",
                                               primaryButtonTitle: "Ok")
    private let viewStateThree = DialogViewState(title: "Dialog 3",
                                                 subtitle: "All of this text is the dialog subtitle. It can be very long.",
                                                 primaryButtonTitle: "Ok",
                                                 secondaryButtonTitle: "Cancel")
    
    var body: some View {
        VStack {
            SplytButton(text: "Open Dialog 1") { dialogOneOpen = true }
            SplytButton(text: "Open Dialog 2") { dialogTwoOpen = true }
            SplytButton(text: "Open Dialog 3") { dialogThreeOpen = true }
        }
        .padding(.horizontal, Layout.size(2))
        .dialog(isOpen: dialogOneOpen,
                viewState: viewStateOne,
                primaryAction: { dialogOneOpen = false })
        .dialog(isOpen: dialogTwoOpen,
                viewState: viewStateTwo,
                primaryAction: { dialogTwoOpen = false })
        .dialog(isOpen: dialogThreeOpen,
                viewState: viewStateThree,
                primaryAction: { print("Ok") },
                secondaryAction: { dialogThreeOpen = false}) {
            SetEntry(id: "some-entry", title: "Reps", inputType: .reps, doneAction: { _, _ in })
        }
    }
}
