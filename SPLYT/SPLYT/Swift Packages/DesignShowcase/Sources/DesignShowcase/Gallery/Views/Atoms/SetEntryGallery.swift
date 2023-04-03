import SwiftUI
@testable import DesignSystem

struct SetEntryGallery: View {
    var body: some View {
        VStack {
            Spacer()
            SetEntry(title: "lbs",
                     input: .weight(12.5)) { value in
                print("Value: \(value)")
            }
            SetEntry(title: "reps",
                     input: .reps(0)) { value in
                print("Value: \(value)")
            }
            Spacer()
        }
    }
}
