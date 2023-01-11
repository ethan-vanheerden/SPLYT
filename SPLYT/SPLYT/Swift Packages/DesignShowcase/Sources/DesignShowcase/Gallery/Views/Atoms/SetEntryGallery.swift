import SwiftUI
import DesignSystem

struct SetEntryGallery: View {
    var body: some View {
        VStack {
            Spacer()
            SetEntry(id: "set-1",
                     title: "lbs",
                     placeholder: "12.5",
                     inputType: .weight) { id, value in
                print("ID: \(id), Weight: \(value)")
            }
            SetEntry(id: "set-2",
                     title: "REPS",
                     placeholder: "0",
                     inputType: .reps) { id, value in
                print("ID: \(id), Reps: \(value)")
            }
            Spacer()
        }
    }
}
