import SwiftUI

/// Heavily borrowed from https://github.com/pBoelck/CustomSegmentedControl

public struct SegmentedControl: View {
    @Binding private var selectedIndex: Int
    @State private var frames: Array<CGRect>
    @State private var backgroundFrame = CGRect.zero
    @State private var isScrollable = true
    private let titles: [String]

    public init(selectedIndex: Binding<Int>, titles: [String]) {
        self._selectedIndex = selectedIndex
        self.titles = titles
        self.frames = Array<CGRect>(repeating: .zero, count: titles.count)
    }

    public var body: some View {
        VStack {
            if isScrollable {
                ScrollViewReader { scrollView in
                    ScrollView(.horizontal, showsIndicators: false) {
                        mainView
                    }
                    .onChange(of: selectedIndex) { _ in
                        withAnimation {
                            scrollView.scrollTo(selectedIndex, anchor: .bottom)
                        }
                    }
                }
                
            } else {
                mainView
            }
        }
        .background(
            GeometryReader { proxy in
                Color.clear.preference(key: RectPreferenceKey.self, value: proxy.frame(in: .global))
                    .onPreferenceChange(RectPreferenceKey.self) {
                    self.setBackgroundFrame(frame: $0)
                }
            }
        )
    }
    
    private var mainView: some View {
        SegmentedControlButtonView(selectedIndex: $selectedIndex,
                                   frames: $frames,
                                   backgroundFrame: $backgroundFrame,
                                   isScrollable: $isScrollable,
                                   checkIsScrollable: checkIsScrollable,
                                   titles: titles)
    }

    private func setBackgroundFrame(frame: CGRect) {
        backgroundFrame = frame
        checkIsScrollable()
    }

    private func checkIsScrollable() {
        if frames[frames.count - 1].width > .zero {
            var width = CGFloat.zero

            for frame in frames {
                width += frame.width
            }

            if isScrollable && width <= backgroundFrame.width {
                isScrollable = false
            } else if !isScrollable && width > backgroundFrame.width {
                isScrollable = true
            }
        }
    }
}

private struct SegmentedControlButtonView: View {
    @Binding private var selectedIndex: Int
    @Binding private var frames: [CGRect]
    @Binding private var backgroundFrame: CGRect
    @Binding private var isScrollable: Bool
    private let titles: [String]
    private let checkIsScrollable: (() -> Void)

    fileprivate init(selectedIndex: Binding<Int>,
         frames: Binding<[CGRect]>,
         backgroundFrame: Binding<CGRect>,
         isScrollable: Binding<Bool>,
         checkIsScrollable: (@escaping () -> Void),
         titles: [String]) {
            self._selectedIndex = selectedIndex
            self._frames = frames
            self._backgroundFrame = backgroundFrame
            self._isScrollable = isScrollable
            self.checkIsScrollable = checkIsScrollable
            self.titles = titles
    }

    var body: some View {
        HStack(spacing: 0) {
            ForEach(titles.indices, id: \.self) { index in
                Button(action: { selectedIndex = index }) {
                    HStack {
                        Spacer()
                        Text(titles[index])
                            .footnote()
                            .foregroundColor(selectedIndex == index ? .black : .gray)
                        Spacer()
                        
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(CustomSegmentButtonStyle())
                .background(
                    GeometryReader { proxy in
                        Color.clear.preference(key: RectPreferenceKey.self, value: proxy.frame(in: .global))
                            .onPreferenceChange(RectPreferenceKey.self) {
                                self.setFrame(index: index, frame: $0)
                            }
                    }
                )
            }
        }
        .modifier(UnderlineModifier(selectedIndex: selectedIndex, frames: frames))
        .animation(.default, value: selectedIndex)
    }

    private func setFrame(index: Int, frame: CGRect) {
        self.frames[index] = frame
        checkIsScrollable()
    }
}

private struct CustomSegmentButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .padding(EdgeInsets(top: Layout.size(1.5), 
                                leading: Layout.size(2),
                                bottom: Layout.size(1.5),
                                trailing: Layout.size(2)))
    }
}


/// This modifier provides an animated underscore for the SegmentedControl.
private struct UnderlineModifier: ViewModifier {
    @EnvironmentObject private var userTheme: UserTheme
    private var selectedIndex: Int
    private let frames: [CGRect]
    
    fileprivate init(selectedIndex: Int, frames: [CGRect]) {
        self.selectedIndex = selectedIndex
        self.frames = frames
    }

    func body(content: Content) -> some View {
        content
            .background(
                Rectangle()
                    .fill(Color(splytColor: userTheme.theme).gradient)
                    .frame(width: frames[selectedIndex].width, height: Layout.size(0.4))
                    .offset(x: frames[selectedIndex].minX - frames[0].minX), alignment: .bottomLeading
            )
            .background(
                Rectangle()
                    .fill(Color(splytColor: .gray).opacity(0.5))
                    .frame(height: 1), alignment: .bottomLeading
            )
    }
}

/// This PeferenceKey is used to pass a CGRect value from the child view to the parent view.
fileprivate struct RectPreferenceKey: PreferenceKey {
    typealias Value = CGRect
    static var defaultValue = CGRect.zero

    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}
