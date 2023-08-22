//
//  DoWorkoutView.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 5/17/23.
//

import Foundation
import SwiftUI
import Core
import DesignSystem

struct DoWorkoutView<VM: TimeViewModel<DoWorkoutViewState, DoWorkoutViewEvent>>: View {
    @ObservedObject private var viewModel: VM
    @State private var countdownSeconds: Int = 3
    @State private var restFABPresenting = false
    private let navigationRouter: DoWorkoutNavigationRouter
    private let countdownTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    private let horizontalPadding: CGFloat = Layout.size(2)
    
    init(viewModel: VM,
         navigationRouter: DoWorkoutNavigationRouter) {
        self.viewModel = viewModel
        self.navigationRouter = navigationRouter
    }
    
    var body: some View {
        switch viewModel.viewState {
        case .loading:
            ProgressView()
        case .error:
            Text("Error")
        case .loaded(let display):
            mainView(display: display)
        case .exit(let display):
            mainView(display: display)
                .onAppear {
                    navigationRouter.navigate(.exit)
                }
        }
    }
    
    @ViewBuilder
    private func mainView(display: DoWorkoutDisplay) -> some View {
        ZStack {
            workoutView(display: display)
            countdownView
                .isVisible(display.inCountdown)
                .animation(.default, value: display.inCountdown)
        }
        .dialog(isOpen: display.presentedDialog == .finishWorkout,
                viewState: display.finishDialog,
                primaryAction: { viewModel.send(.saveWorkout, taskPriority: .userInitiated) }, // TODO: progress indicator?
                secondaryAction: { viewModel.send(.toggleDialog(dialog: .finishWorkout, isOpen: false),
                                                  taskPriority: .userInitiated) })
    }
    
    @ViewBuilder
    private func workoutView(display: DoWorkoutDisplay) -> some View {
        ZStack {
            VStack {
                // Would have to make this a ZStack to have a blur effect look good
                headerView(display: display)
                ScrollView(showsIndicators: false) {
                    groupsView(display: display)
                        .padding(.bottom, Layout.size(2))
                }
            }
            RestFAB(isPresenting: $restFABPresenting,
                    workoutSeconds: .constant(viewModel.secondsElapsed),
                    viewState: display.restFAB,
                    selectRestAction: { viewModel.send(.toggleRest(isResting: true), taskPriority: .userInitiated) },
                    stopRestAction: { viewModel.send(.toggleRest(isResting: false), taskPriority: .userInitiated) })
        }
    }
    
    @ViewBuilder
    private func headerView(display: DoWorkoutDisplay) -> some View {
        VStack {
            HStack(spacing: Layout.size(1)) {
                Text(TimeUtils.hrMinSec(seconds: viewModel.secondsElapsed))
                    .title1()
                    .foregroundColor(display.isResting ? Color(splytColor: .lightBlue) : Color(splytColor: .black))
                Spacer()
                IconButton(iconName: "pencil", action: { })
                    .isVisible(false) // TODO: 51: Workout notes
                IconButton(iconName: "book.closed", action: { })
                    .isVisible(false) // TODO: 54: Workout logs
                SplytButton(text: Strings.finish) {
                    viewModel.send(.toggleDialog(dialog: .finishWorkout, isOpen: true),
                                   taskPriority: .userInitiated)
                }
                .fixedSize()
            }
            ProgressBar(viewState: display.progressBar)
            Divider()
        }
        .padding(.horizontal, horizontalPadding)
    }
    
    @ViewBuilder
    private var countdownView: some View {
        HStack {
            Spacer()
            VStack {
                Spacer()
                Text("\(countdownSeconds)")
                    .largeTitle()
                Text(Strings.enjoyYourLift)
                    .title1()
                Spacer()
            }
            .foregroundColor(Color(splytColor: .white))
            Spacer()
        }
//        .background(LinearGradient(colors: [Color(splytColor: .purple),
//                                            Color(splytColor: .lightBlue)], // TODO: 45: gradients
//                                   startPoint: .bottom, endPoint: .top))
        .background(SplytGradient.classic.gradient(startPoint: .top, endPoint: .bottom))
        .onReceive(countdownTimer) { _ in
            if countdownSeconds <= 0 {
                countdownTimer.upstream.connect().cancel() // Can only have one timer running at a time idk
                viewModel.send(.stopCountdown, taskPriority: .userInitiated)
            } else {
                countdownSeconds -= 1
            }
        }
    }
    
    @ViewBuilder
    private func groupsView(display: DoWorkoutDisplay) -> some View {
        ForEach(Array(display.groups.enumerated()), id: \.offset) { groupIndex, group in
            DoExerciseGroupView(isExpanded: groupExpandBinding(group: groupIndex,
                                                               expandedGroups: display.expandedGroups),
                                viewState: group,
                                addSetAction: { viewModel.send(.addSet(group: groupIndex),
                                                               taskPriority: .userInitiated) },
                                removeSetAction: { viewModel.send(.removeSet(group: groupIndex),
                                                                  taskPriority: .userInitiated) },
                                updateSetAction: { exerciseIndex, setIndex, setInput in
                viewModel.send(.updateSet(group: groupIndex,
                                          exerciseIndex: exerciseIndex,
                                          setIndex: setIndex,
                                          with: setInput,
                                          forModifier: false),
                               taskPriority: .userInitiated)
            },
                                updateModifierAction: { exerciseIndex, setIndex, setInput in
                viewModel.send(.updateSet(group: groupIndex,
                                          exerciseIndex: exerciseIndex,
                                          setIndex: setIndex,
                                          with: setInput,
                                          forModifier: true),
                               taskPriority: .userInitiated)
            },
                                usePreviousInputAction: { exerciseIndex, setIndex, forModifier in
                viewModel.send(.usePreviousInput(group: groupIndex,
                                                 exerciseIndex: exerciseIndex,
                                                 setIndex: setIndex,
                                                 forModifier: forModifier),
                               taskPriority: .userInitiated)
            },
                                addNoteAction: { }, // TODO: add notes
                                finishSlideAction: { viewModel.send(.completeGroup(group: groupIndex),
                                                                    taskPriority: .userInitiated) })
            .padding(.horizontal, horizontalPadding)
        }
        .animation(.default, value: display.expandedGroups) // Preserves collapse animation
    }
    
    private func groupExpandBinding(group: Int, expandedGroups: [Bool]) -> Binding<Bool> {
        return Binding(
            get: { return expandedGroups[group] },
            set: { viewModel.send(.toggleGroupExpand(group: group, isExpanded: $0),
                                  taskPriority: .userInitiated) }
        )
    }
}

fileprivate struct Strings {
    static let enjoyYourLift = "Enjoy your lift 🔥!"
    static let finish = "Finish"
}
