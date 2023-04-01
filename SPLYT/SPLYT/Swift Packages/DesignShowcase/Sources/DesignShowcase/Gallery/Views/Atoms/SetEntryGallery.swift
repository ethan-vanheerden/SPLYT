import SwiftUI
@testable import DesignSystem

struct SetEntryGallery: View {
    var body: some View {
        VStack {
            Spacer()
            SetEntry(title: "lbs",
                     inputType: .weight(12.5)) { value in
                print("Value: \(value)")
            }
            SetEntry(title: "reps",
                     inputType: .reps(0)) { value in
                print("Value: \(value)")
            }
            Spacer()
        }
    }
}
