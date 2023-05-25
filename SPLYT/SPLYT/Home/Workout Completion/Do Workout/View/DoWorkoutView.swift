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
    }
    
    @ViewBuilder
    private func workoutView(display: DoWorkoutDisplay) -> some View {
        ZStack {
            VStack {
                // Would have to make this a ZStack to have a blur effect look good
                headerView(display: display)
                ScrollView(showsIndicators: false) {
                    ForEach(Array(display.groups.enumerated()), id: \.offset) { groupIndex, exercises in
                        CollapseHeader(isExpanded: .constant(true),
                                       viewState: .init(title: display.groupTitles[groupIndex],
                                                        color: .lightBlue)) {
                            groupView(exercises: exercises)
                        }
                    }
                    .padding(.bottom, Layout.size(4))
                    SplytButton(text: "Finish Workout") {
                        // TODO
                    }
                    .padding(.horizontal, Layout.size(2)) // TODO: move to ZStack?
                }
            }
            RestFAB(isPresenting: $restFABPresenting,
                    workoutSeconds: .constant(viewModel.secondsElapsed),
                    viewState: .init(isResting: display.isResting, restPresets: [60, 100, 120]),
                    selectRestAction: { viewModel.send(.toggleRest(isResting: true), taskPriority: .userInitiated) },
                    stopRestAction: { viewModel.send(.toggleRest(isResting: false), taskPriority: .userInitiated) })
        }
//        .animation(.default, value: display.isResting) // This animates the FAB change but it looks weird
    }
    
    @ViewBuilder
    private func headerView(display: DoWorkoutDisplay) -> some View {
        VStack {
            HStack {
                Text(TimeUtils.hrMinSec(seconds: viewModel.secondsElapsed))
                    .title1()
                    .foregroundColor(display.isResting ? Color(splytColor: .lightBlue) : Color(splytColor: .black))
                Spacer()
                IconButton(iconName: "pencil", action: { })
                IconButton(iconName: "book.closed", action: { })
            }
            Divider() // TODO: don't like
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
                Text("Enjoy your lift 🏋️!")
                    .title1()
                Spacer()
            }
            .foregroundColor(Color(splytColor: .white))
            Spacer()
        }
        .background(LinearGradient(colors: [Color(splytColor: .purple),
                                            Color(splytColor: .lightBlue)], // TODO: 45: gradients
                                   startPoint: .bottom, endPoint: .top))
        .onReceive(countdownTimer) { _ in
            if countdownSeconds <= 0 {
                countdownTimer.upstream.connect().cancel() // Can only have one timer running at a time because...
                viewModel.send(.stopCountdown, taskPriority: .userInitiated)
            } else {
                countdownSeconds -= 1
            }
        }
    }
    
    @ViewBuilder
    private func groupView(exercises: [ExerciseViewState]) -> some View {
        VStack {
            ForEach(exercises, id: \.self) { exercise in
                ExerciseView(viewState: exercise,
                             type: .inProgress(usePreviousAction: { _ in },
                                               addNoteAction: { }),
                             addSetAction: { },
                             removeSetAction: { },
                             updateSetAction: { _, _ in },
                             updateModifierAction: { _, _ in })
            }
        }
    }
}
