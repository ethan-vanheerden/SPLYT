import SwiftUI
import DesignSystem

struct ColorGallery: View {
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(SplytColor.allCases, id: \.self) { color in
                        Text(color.rawValue)
                            .descriptionText()
                            .frame(width: proxy.size.width / 2.2, height: Layout.size(6))
                            .roundedBackground(cornerRadius: Layout.size(0.5),
                                               fill: Color.splytColor(color))
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

struct ColorGallery_Previews: PreviewProvider {
    static var previews: some View {
        ColorGallery()
    }
}
