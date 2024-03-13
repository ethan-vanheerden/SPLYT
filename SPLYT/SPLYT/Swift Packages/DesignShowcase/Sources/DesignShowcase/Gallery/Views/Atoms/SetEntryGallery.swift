import SwiftUI
import DesignSystem

struct SetEntryGallery: View {
    @State private var textOne = ""
    @State private var textTwo = "12"
    
    var body: some View {
        VStack {
            Spacer()
            SetEntry(input: textOne,
                     title: "lbs",
                     keyboardType: .weight,
                     placeholder: "12",
                     updateAction: { textOne = $0 })
            
            SetEntry(input: textTwo,
                     title: "reps",
                     keyboardType: .reps,
                     updateAction: { textTwo = $0 })
            Spacer()
        }
    }
}
