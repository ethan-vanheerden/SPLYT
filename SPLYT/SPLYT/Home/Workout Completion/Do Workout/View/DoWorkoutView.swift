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
    @State private var showSetModifiers: Bool = false
    @State private var editGroupIndex: Int = 0
    @State private var editExerciseIndex: Int = 0
    @State private var editSetIndex: Int = 0
    @EnvironmentObject private var userTheme: UserTheme
    private let navigationRouter: DoWorkoutNavigationRouter
    private let transformer: WorkoutTransformer = .init()
    private let countdownTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    private let horizontalPadding: CGFloat = Layout.size(2)
    
    init(viewModel: VM,
         navigationRouter: DoWorkoutNavigationRouter,
         fromCache: Bool = false) {
        self.viewModel = viewModel
        self.navigationRouter = navigationRouter
        
        if fromCache {
            countdownTimer.upstream.connect().cancel() // There won't be a countdown
            viewModel.send(.loadWorkout, taskPriority: .userInitiated)
        }
    }
    
    var body: some View {
        switch viewModel.viewState {
        case .loading:
            ProgressView()
        case .error:
            ErrorView(retryAction: { viewModel.send(.loadWorkout, taskPriority: .userInitiated) },
                      backAction: { navigationRouter.navigate(.exit())} )
        case .loaded(let display):
            mainView(display: display)
        case .exit(let display):
            mainView(display: display)
                .onAppear {
                    navigationRouter.navigate(.exit(workoutDetailsId: display.workoutDetailsId))
                }
        }
    }
    
    @ViewBuilder
    private func mainView(display: DoWorkoutDisplay) -> some View {
        ZStack {
            workoutView(display: display)
            countdownView(inCountdown: display.inCountdown)
                .isVisible(display.inCountdown)
                .animation(.default, value: display.inCountdown)
        }
        .dialog(isOpen: display.presentedDialog == .finishWorkout,
                viewState: display.finishDialog,
                primaryAction: { viewModel.send(.saveWorkout, taskPriority: .userInitiated) },
                secondaryAction: { viewModel.send(.toggleDialog(dialog: .finishWorkout, isOpen: false),
                                                  taskPriority: .userInitiated) })
        .sheet(isPresented: $showSetModifiers) {
            setModifiers
                .presentationDetents([.height(Layout.size(12))])
                .presentationDragIndicator(.visible)
        }
        .onChange(of: viewModel.secondsElapsed) { newValue in
            // We want to update the in progress cache once every 15 seconds
            if newValue != 0 && newValue % 15 == 0 {
                viewModel.send(.cacheWorkout(secondElapsed: newValue),
                               taskPriority: .background)
            }
        }
    }
    
    @ViewBuilder
    private func workoutView(display: DoWorkoutDisplay) -> some View {
        ZStack {
            VStack {
                // Would have to make this a ZStack to have a blur effect look good
                headerView(display: display)
                ScrollView(showsIndicators: false) {
                    groupsView(display: display)
                        .padding(.bottom, Layout.size(10))
                }
            }
            RestFAB(isPresenting: $restFABPresenting,
                    workoutSeconds: .constant(viewModel.secondsElapsed),
                    viewState: display.restFAB,
                    selectRestAction: { restSeconds in
                viewModel.send(.startRest(restSeconds: restSeconds),
                               taskPriority: .userInitiated)
            },
                    stopRestAction: { manuallyStopped in
                viewModel.send(.stopRest(manuallyStopped: manuallyStopped),
                               taskPriority: .userInitiated)
            },
                    pauseAction: {
                viewModel.send(.pauseRest,
                               taskPriority: .userInitiated)
            }, resumeAction: { restSeconds in
                viewModel.send(.resumeRest(restSeconds: restSeconds),
                               taskPriority: .userInitiated)
            })
        }
    }
    
    private func headerView(display: DoWorkoutDisplay) -> some View {
        VStack {
            HStack(spacing: Layout.size(1)) {
                timerView(isResting: display.isResting)
                Spacer()
                IconButton(iconName: "pencil", action: { })
                    .isVisible(false) // TODO: 51: Workout notes
                IconButton(iconName: "book.closed", action: { })
                    .isVisible(false) // TODO: 54: Workout logs
                IconButton(iconName: "plus",
                           iconColor: .white) { 
                    navigationRouter.navigate(.addExercises(addAction: { addedExerciseIds in
                        viewModel.send(.addExercises(exerciseIds: addedExerciseIds),
                                       taskPriority: .userInitiated)
                    }))
                }
                    .padding(.trailing, Layout.size(1))
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
    
    private func timerView(isResting: Bool) -> some View {
        Text(TimeUtils.hrMinSec(seconds: viewModel.secondsElapsed))
            .title1()
            .foregroundStyle(isResting ? Color(userTheme.theme).gradient
                             : Color(SplytColor.label).gradient)
    }
    
    @ViewBuilder
    private func countdownView(inCountdown: Bool) -> some View {
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
            .foregroundColor(Color(SplytColor.white))
            Spacer()
        }
        .background(LinearGradient(colors: [Color(SplytColor.background), userTheme.theme.color],
                                   startPoint: .top,
                                   endPoint: .bottom))
        .onReceive(countdownTimer) { _ in
            if inCountdown && countdownSeconds <= 0 {
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
                                addSetAction: {
                viewModel.send(.addSet(group: groupIndex),
                               taskPriority: .userInitiated)
            },
                                removeSetAction: {
                viewModel.send(.removeSet(group: groupIndex),
                               taskPriority: .userInitiated)
            },
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
                                finishSlideAction: {
                viewModel.send(.completeGroup(group: groupIndex),
                               taskPriority: .userInitiated)
            },
                                replaceExerciseAction: { exerciseIndex in
                navigationRouter.navigate(.replaceExercise(replaceAction: { exerciseId in
                    viewModel.send(.markExerciseLoading(group: groupIndex,
                                                        exerciseIndex: exerciseIndex))
                    viewModel.send(.replaceExercise(group: groupIndex,
                                                    exerciseIndex: exerciseIndex,
                                                    newExerciseId: exerciseId),
                                   taskPriority: .userInitiated)
                }))
            },
                                deleteExerciseAction: { exerciseIndex in
                viewModel.send(.deleteExercise(group: groupIndex,
                                               exerciseIndex: exerciseIndex),
                               taskPriority: .userInitiated)
            },
                                addModifierAction: { exerciseIndex, setIndex in
                // Stores the selected set and exercise for when the modifier is actually added
                editGroupIndex = groupIndex
                editSetIndex = setIndex
                editExerciseIndex = exerciseIndex
                withAnimation {
                    showSetModifiers = true
                }
            },
                                removeModifierAction: { exerciseIndex, setIndex in
                viewModel.send(.removeModifier(group: groupIndex,
                                               exerciseIndex: exerciseIndex,
                                               setIndex: setIndex),
                               taskPriority: .userInitiated)
            },
                                canDeleteExercise: display.canDeleteExercise)
            .padding(.horizontal, horizontalPadding)
        }
        .animation(.default, value: display.expandedGroups) // Preserves collapse animation
    }
    
    @ViewBuilder
    private var setModifiers: some View {
        SetModifiersView { modifierState in
            viewModel.send(.addModifier(group: editGroupIndex,
                                        exerciseIndex: editExerciseIndex,
                                        setIndex: editSetIndex,
                                        modifier: transformer.transformModifier(modifierState)),
                           taskPriority: .userInitiated)
            showSetModifiers = false
        }
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
