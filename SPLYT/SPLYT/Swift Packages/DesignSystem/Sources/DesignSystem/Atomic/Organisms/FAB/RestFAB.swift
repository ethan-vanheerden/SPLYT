import SwiftUI

public struct RestFAB: View {
    @State private var secondsLeft: Int? = nil // Let this view handle the timer countdown interanally
    @State private var isPaused = false
    @State private var showTimePicker = false
    @State private var pickerMinutes = 0
    @State private var pickerSeconds = 0
    @Binding private var isPresenting: Bool
    private let viewState: RestFABViewState
    private let selectRestAction: (Int) -> Void
    private let selectMoreAction: () -> Void
    private let stopAction: () -> Void
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    private let pickerWidth = Layout.size(10)
    
    public init(isPresenting: Binding<Bool>,
                viewState: RestFABViewState,
                selectRestAction: @escaping (Int) -> Void,
                selectMoreAction: @escaping () -> Void,
                stopAction: @escaping () -> Void) {
        self._isPresenting = isPresenting
        self.viewState = viewState
        self.selectRestAction = selectRestAction
        self.selectMoreAction = selectMoreAction
        self.stopAction = stopAction
    }
    
    public var body: some View {
        if secondsLeft != nil {
            restingView
        } else {
            fabView
        }
    }
    
    @ViewBuilder
    private var restingView: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                HStack {
                    Image(systemName: "stopwatch")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(Color(splytColor: .lightBlue))
                        .frame(width: Layout.size(2.5))
                    timeView
                    IconButton(iconName: isPaused ? "play.fill" : "pause",
                               style: .secondary,
                               iconColor: .lightBlue) {
                        isPaused.toggle()
                    }
                    IconButton(iconName: "xmark",
                               style: .secondary,
                               iconColor: .red) {
                        withAnimation {
                            secondsLeft = nil
                            isPaused = false
                        }
                    }
                }
                .padding()
                .background {
                    Capsule()
                        .fill(Color(splytColor: .white).shadow(.drop(radius: Layout.size(2))))
                }
            }
            .padding()
        }
    }
    
    @ViewBuilder
    private var timeView: some View {
        Text(TimeUtils.minSec(seconds: secondsLeft ?? 0))
            .title3()
            .frame(maxWidth: Layout.size(10))
            .onReceive(timer) { input in
                guard let secondsLeft = secondsLeft else { return }
                // Update the countdown and switch back the FAB state if we need to
                if secondsLeft == 0 {
                    withAnimation {
                        self.secondsLeft = nil
                        isPaused = false // Just in case
                    }
                } else if !isPaused {
                    self.secondsLeft = secondsLeft - 1
                }
            }
    }
    
    @ViewBuilder
    private var fabView: some View {
        FAB(isPresenting: $isPresenting,
            baseIcon: baseIcon) {
            fabRows
        }
            .sheet(isPresented: $showTimePicker) {
                restPicker
                    .presentationDetents([.fraction(0.33)])
                    .presentationDragIndicator(.visible)
            }
    }
    
    private var baseIcon: FABIconViewState {
        if isPresenting {
            return FABIconViewState(size: .primary(backgroundColor: .white,
                                                   iconColor: .lightBlue),
                                    imageName: "minus")
        } else {
            return FABIconViewState(size: .primary(backgroundColor: .white,
                                                   iconColor: .lightBlue),
                                    imageName: "stopwatch")
        }
    }
    
    @ViewBuilder
    private var fabRows: some View {
        VStack(alignment: .trailing) {
            FABIcon(viewState: moreIcon) {
                showTimePicker = true
            }
            .offset(y: isPresenting ? 0 : Layout.size(16))
            VStack(spacing: Layout.size(1)) {
                ForEach(Array(viewState.restPresets.enumerated()), id: \.offset) { index, seconds in
                    let verticalOffset = CGFloat((viewState.restPresets.count - index) * 6)
                    RestFABRow(seconds: seconds) {
                        isPresenting = false
                        withAnimation {
                            secondsLeft = seconds
                        }
                    }
                    .offset(x: Layout.size(1), y: isPresenting ? 0 : Layout.size(verticalOffset))
                }
            }
        }
        .isVisible(isPresenting)
        .padding(.trailing, Layout.size(2))
    }
    
    private var moreIcon: FABIconViewState {
        return FABIconViewState(size: .secondary(backgroundColor: .white,
                                                 iconColor: .lightBlue),
                                imageName: "ellipsis")
    }
    
    private var restPicker: some View {
        VStack {
            HStack {
                Picker(Strings.min, selection: $pickerMinutes) {
                    ForEach(0...10, id: \.self) { minute in
                        Text("\(minute)")
                    }
                }
                .frame(width: pickerWidth)
                Text(Strings.min)
                Picker(Strings.sec, selection: $pickerSeconds) {
                    ForEach(0...60, id: \.self) { second in
                        Text("\(second)")
                    }
                }
                .frame(width: pickerWidth)
                Text(Strings.sec)
            }
            .pickerStyle(.wheel)
            Spacer()
            pickerButtons
        }
        
    }
    
    private var pickerButtons: some View {
        HStack(spacing: Layout.size(2)) {
            SplytButton(text: "Cancel",
                        color: .white,
                        textColor: .gray,
                        outlineColor: .gray) {
                showTimePicker = false
            }
            SplytButton(text: "Confirm",
                        isEnabled: !(pickerSeconds == 0 && pickerMinutes == 0)) {
                showTimePicker = false
                isPresenting = false
                secondsLeft = TimeUtils.getSeconds(minutes: pickerMinutes, seconds: pickerSeconds)
            }
        }
        .padding(.horizontal, Layout.size(2))
    }
}

// MARK: - View State

public struct RestFABViewState: Equatable {
    let restPresets: [Int] // In seconds the amount of rest the user's presets are
    
    public init(restPresets: [Int]) {
        self.restPresets = restPresets
    }
}

// MARK: - Strings

fileprivate struct Strings {
    static let min = "min"
    static let sec = "sec"
}
