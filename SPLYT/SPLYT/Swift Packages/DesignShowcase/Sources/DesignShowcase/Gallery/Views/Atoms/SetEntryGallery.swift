import SwiftUI
import DesignSystem

struct SetEntryGallery: View {
    @State private var textOne = ""
    @State private var textTwo = "12"
    var body: some View {
        VStack {
            Spacer()
            SetEntry(input: $textOne,
                     title: "lbs",
                     keyboardType: .weight,
                     placeholder: "12",
                     tag: 1)
            SetEntry(input: $textTwo,
                     title: "reps",
                     keyboardType: .reps,
                     tag: 2)
            Spacer()
        }
    }
}
