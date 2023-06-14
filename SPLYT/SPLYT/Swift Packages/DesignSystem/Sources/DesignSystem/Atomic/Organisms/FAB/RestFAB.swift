import SwiftUI
import Core

public struct RestFAB: View {
    @State private var secondsLeft: Int = 0 // The current number of seconds left in current rest period
    @State private var isPaused = false
    @State private var showTimePicker = false
    @State private var pickerMinutes = 0
    @State private var pickerSeconds = 0
    @Binding private var isPresenting: Bool
    @Binding private var workoutSeconds: Int // Total number of seconds elapsed in the workout
    private let viewState: RestFABViewState
    private let selectRestAction: () -> Void
    private let stopRestAction: () -> Void
    
    public init(isPresenting: Binding<Bool>,
                workoutSeconds: Binding<Int>,
                viewState: RestFABViewState,
                selectRestAction: @escaping () -> Void,
                stopRestAction: @escaping () -> Void) {
        self._isPresenting = isPresenting
        self._workoutSeconds = workoutSeconds
        self.viewState = viewState
        self.selectRestAction = selectRestAction
        self.stopRestAction = stopRestAction
    }
    
    public var body: some View {
        if viewState.isResting {
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
                    Image(systemName: "stopwatch") // TODO: icon images
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
                        stopRest()
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
        Text(TimeUtils.minSec(seconds: secondsLeft))
            .title3()
            .frame(maxWidth: Layout.size(10))
            .onChange(of: workoutSeconds) { newValue in
                // Get the relative time changed in case of backgrounding
                let delta = newValue - workoutSeconds
                
                // Update the countdown and switch back the FAB state if we need to
                if secondsLeft - delta < 0 {
                    stopRest()
                } else if !isPaused {
                    secondsLeft -= delta
                }
            }
    }
    
    /// All the actions to be done when the rest period should be stopped
    private func stopRest() -> Void {
        withAnimation {
            secondsLeft = 0
            isPaused = false
            stopRestAction()
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
            .offset(y: isPresenting ? 0 : Layout.size(16)) // TODO: find another way since picker gets messed up with timer
            VStack(spacing: Layout.size(1)) {
                ForEach(Array(viewState.restPresets.enumerated()), id: \.offset) { index, seconds in
                    let verticalOffset = CGFloat((viewState.restPresets.count - index) * 6)
                    RestFABRow(seconds: seconds) {
                        isPresenting = false
                        withAnimation {
                            selectRestAction()
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
            Spacer()
            HStack {
                Counter(selectedNumber: $pickerMinutes,
                        viewState: CounterViewState(maxNumber: 10,
                                                    label: Strings.min,
                                                    backGroundColor: .lightBlue,
                                                    textColor: .black))
                Counter(selectedNumber: $pickerSeconds,
                        viewState: CounterViewState(maxNumber: 60,
                                                    label: Strings.sec,
                                                    backGroundColor: .lightBlue,
                                                    textColor: .black))
            }
            Spacer()
            pickerButtons
        }
    }
    
    private var pickerButtons: some View {
        HStack(spacing: Layout.size(2)) {
            SplytButton(text: "Cancel",
                        type: .primary(color: .white),
                        textColor: .gray) {
                showTimePicker = false
            }
            SplytButton(text: "Confirm",
                        isEnabled: !(pickerSeconds == 0 && pickerMinutes == 0)) {
                showTimePicker = false
                isPresenting = false
                selectRestAction()
                secondsLeft = TimeUtils.getSeconds(minutes: pickerMinutes, seconds: pickerSeconds)
            }
        }
        .padding(.horizontal, Layout.size(2))
    }
}

// MARK: - View State

public struct RestFABViewState: Equatable {
    fileprivate let isResting: Bool
    fileprivate let restPresets: [Int] // In seconds the amount of rest the user's presets are
    
    public init(isResting: Bool,
                restPresets: [Int]) {
        self.isResting = isResting
        self.restPresets = restPresets
    }
}

// MARK: - Strings

fileprivate struct Strings {
    static let min = "min"
    static let sec = "sec"
}
