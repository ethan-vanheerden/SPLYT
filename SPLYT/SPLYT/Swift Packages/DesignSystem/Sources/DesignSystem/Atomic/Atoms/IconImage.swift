import SwiftUI

public struct IconImage: View {
    private let imageName: String // SF Symbol name
    private let imageColor: SplytColor
    private let backgroundColor: SplytColor
    private let backgroundSize = Layout.size(4)
    private let cornerRadius = Layout.size(1)
    
    public init(imageName: String,
                imageColor: SplytColor = .white,
                backgroundColor: SplytColor) {
        self.imageName = imageName
        self.imageColor = imageColor
        self.backgroundColor = backgroundColor
    }
    
    public var body: some View {
        image
            .frame(width: backgroundSize, height: backgroundSize)
            .foregroundColor(Color(splytColor: imageColor))
            .roundedBackground(cornerRadius: cornerRadius,
                               fill: Color(splytColor: backgroundColor))
    }
    
    @ViewBuilder
    private var image: some View {
        HStack {
            Spacer()
            VStack {
                Spacer()
                Image(systemName: imageName)
                    .imageScale(.large)
                Spacer()
            }
            Spacer()
        }
    }
}
