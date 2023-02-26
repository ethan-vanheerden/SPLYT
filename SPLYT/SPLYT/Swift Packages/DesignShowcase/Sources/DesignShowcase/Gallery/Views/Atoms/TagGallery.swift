import SwiftUI
import DesignSystem

struct TagGallery: View {
    var body: some View {
        VStack(spacing: Layout.size(1)) {
            Spacer()
            Tag(text: "DROP SET", fill: Color(splytColor: .red))
            Tag(text: "REST PAUSE", fill: Color(splytColor: .green))
            Tag(text: "ECCENTRIC", fill: Color(splytColor: .yellow))
            Tag(text: "UNICORN VOMIT", fill: AngularGradient(colors: [.red, .green, .blue, .purple, .pink],
                                                             center: .center,
                                                             startAngle: .degrees(90),
                                                             endAngle: .degrees(360)))
            Spacer()
        }
        .padding(.horizontal)
    }
}
