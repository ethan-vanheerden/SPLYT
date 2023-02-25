
import SwiftUI
import DesignSystem

struct DialogGallery: View {
    @State private var dialogOneOpen = false
    @State private var dialogTwoOpen = false
    @State private var dialogThreeOpen = false
    
    var body: some View {
        VStack {
            SplytButton(text: "Open Dialog 1") { dialogOneOpen = true }
            SplytButton(text: "Open Dialog 2") { dialogTwoOpen = true }
            SplytButton(text: "Open Dialog 3") { dialogThreeOpen = true }
        }
        .padding(.horizontal, Layout.size(2))
        .dialog(isOpen: dialogOneOpen,
                title: "Dialog 1",
                type: .singleAction(title: "Ok",
                                    action: { dialogOneOpen = false }))
        .dialog(isOpen: dialogTwoOpen,
                title: "Dialog 2",
                subtitle: "All of this text is the dialog subtitle. It can be very long.",
                type: .singleAction(title: "Ok",
                                    action: { dialogTwoOpen = false }))
        .dialog(isOpen: dialogThreeOpen,
                title: "Dialog 3",
                subtitle: "All of this text is the dialog subtitle. It can be very long. It also has an additional view!",
                type: .dualAction(primaryTitle: "Ok",
                                  primaryAction: { print("Ok") },
                                  secondaryTitle: "Cancel",
                                  secondaryAction: { dialogThreeOpen = false})) {
            SetEntry(id: "some-entry", title: "Reps", inputType: .reps, doneAction: { _, _ in })
        }
    }
}

struct DialogGallery_Previews: PreviewProvider {
    static var previews: some View {
        DialogGallery()
    }
}
