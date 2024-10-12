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
    @EnvironmentObject private var userTheme: UserTheme
    private let viewState: RestFABViewState
    private let selectRestAction: (Int) -> Void
    private let stopRestAction: (Bool) -> Void // Bool for whether the user manually stopped it
    private let pauseAction: () -> Void
    private let resumeAction: (Int) -> Void
    
    public init(isPresenting: Binding<Bool>,
                workoutSeconds: Binding<Int>,
                viewState: RestFABViewState,
                selectRestAction: @escaping (Int) -> Void,
                stopRestAction: @escaping (Bool) -> Void,
                pauseAction: @escaping () -> Void,
                resumeAction: @escaping (Int) -> Void) {
        self._isPresenting = isPresenting
        self._workoutSeconds = workoutSeconds
        self.viewState = viewState
        self.selectRestAction = selectRestAction
        self.stopRestAction = stopRestAction
        self.pauseAction = pauseAction
        self.resumeAction = resumeAction
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
                    Image(systemName: "stopwatch")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(Color(userTheme.theme))
                        .frame(width: Layout.size(2.5))
                    timeView
                    IconButton(iconName: isPaused ? "play.fill" : "pause",
                               style: .secondary,
                               iconColor: userTheme.theme) {
                        isPaused.toggle()
                        isPaused ? pauseAction() : resumeAction(secondsLeft)
                    }
                    IconButton(iconName: "xmark",
                               style: .secondary,
                               iconColor: .red) {
                        stopRest(isManual: true)
                    }
                }
                .padding()
                .background {
                    Capsule()
                        .fill(Color(SplytColor.background).gradient.shadow(.drop(color: Color(SplytColor.shadow),
                                                                                 radius: Layout.size(1.25))))
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
                    stopRest(isManual: false)
                } else if !isPaused {
                    secondsLeft -= delta
                }
            }
    }
    
    /// All the actions to be done when the rest period should be stopped
    private func stopRest(isManual: Bool) -> Void {
        withAnimation {
            secondsLeft = 0
            isPaused = false
            stopRestAction(isManual)
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
        return FABIconViewState(size: .primary(backgroundColor: .background,
                                               iconColor: userTheme.theme),
                                imageName: isPresenting ? "minus" : "stopwatch")
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
                            selectRestAction(seconds)
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
        return FABIconViewState(size: .secondary(backgroundColor: .background,
                                                 iconColor: userTheme.theme),
                                imageName: "ellipsis")
    }
    
    private var restPicker: some View {
        RestPicker(minutes: $pickerMinutes,
                   seconds: $pickerSeconds,
                   confirmAction: {
            showTimePicker = false
            isPresenting = false
            secondsLeft = TimeUtils.getTotalSeconds(minutes: pickerMinutes, seconds: pickerSeconds)
            selectRestAction(secondsLeft)
        },
                   cancelAction: {
            showTimePicker = false
        })
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
