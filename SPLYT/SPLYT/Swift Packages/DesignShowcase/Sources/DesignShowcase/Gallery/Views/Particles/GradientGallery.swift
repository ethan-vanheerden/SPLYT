import SwiftUI
import DesignSystem

struct GradientGallery: View {
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(SplytGradient.allCases, id: \.self) { gradient in
                        Text(gradient.rawValue)
                            .footnote()
                            .foregroundColor(Color(splytColor: .white))
                            .frame(width: proxy.size.width / 2.2, height: Layout.size(6))
                            .roundedBackground(cornerRadius: Layout.size(0.5),
                                               fill: gradient.gradient())
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}
