//
//  WorkoutPreviewView.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 5/18/23.
//

import Foundation
import SwiftUI
import Core
import DesignSystem

/// Making all the associated types the same objects for the `DoWorkout` flow for simplicity
struct WorkoutPreviewView<VM: ViewModel>: View where VM.Event == DoWorkoutViewEvent, VM.ViewState == DoWorkoutViewState {
    @ObservedObject private var viewModel: VM
    @State private var navTitle = ""
    private let navigationRouter: DoWorkoutNavigationRouter
    private let horizontalPadding: CGFloat = Layout.size(2)
    
    init(viewModel: VM,
         navigationRouter: DoWorkoutNavigationRouter) {
        self.viewModel = viewModel
        self.navigationRouter = navigationRouter
        self.viewModel.send(.loadWorkout, taskPriority: .userInitiated)
    }
    
    var body: some View {
        viewStateView
            .navigationBar(viewState: NavigationBarViewState(title: navTitle),
                           backAction: { navigationRouter.navigate(.back) })
    }
    
    @ViewBuilder
    private var viewStateView: some View {
        switch viewModel.viewState {
        case .loading:
            ProgressView()
        case .error, .exit: // Should never get the .exit state in this view
            Text("Error!")
        case .loaded(let display):
            mainView(display: display)
                .onAppear {
                    navTitle = display.workoutName // Update if we were able to load the workout
                }
        }
    }
    
    @ViewBuilder
    private func mainView(display: DoWorkoutDisplay) -> some View {
        VStack {
            ScrollView(showsIndicators: false) {
                ForEach(Array(display.groups.enumerated()), id: \.offset) { groupIndex, group in
                    groupView(title: display.groupTitles[groupIndex],
                              group: group)
                    .padding(.bottom, Layout.size(0.5))
                }
                .padding(.top, Layout.size(1))
            }
            SplytButton(text: Strings.beginWorkout){
                navigationRouter.navigate(.beginWorkout)
            } // TODO: on this action we can probs just pop this view since we won't be able to come back to it
                .padding(.horizontal, horizontalPadding)
        }
    }
    
    @ViewBuilder
    private func groupView(title: String, group: DoExerciseGroupViewState) -> some View {
        Tile {
            VStack {
                HStack {
                    Text(title)
                        .title3()
                        .foregroundColor(Color(splytColor: .lightBlue))
                    Spacer()
                }
                .padding(.bottom, Layout.size(0.5))
                ForEach(group.exercises, id: \.self) { exercise in
                    HStack {
                        SectionHeader(viewState: exercise.header)
                        Text(exercise.numSetsTitle)
                            .body(style: .medium)
                    }
                    .padding(.bottom, Layout.size(0.5))
                }
            }
        }
        .padding(.horizontal, horizontalPadding)
    }
}

// MARK: - Strings

fileprivate struct Strings {
    static let beginWorkout = "Begin Workout"
    static let sets = "Sets"
}
