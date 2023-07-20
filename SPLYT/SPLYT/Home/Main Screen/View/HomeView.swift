//
//  HomeView.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 7/16/22.
//

import SwiftUI
import Core
import DesignSystem
import ExerciseCore

struct HomeView<VM: ViewModel>: View where VM.Event == HomeViewEvent, VM.ViewState == HomeViewState {
    @ObservedObject private var viewModel: VM
    @State private var segmentedControlIndex = 0
    @State private var fabPresenting = false
    private let navigationRouter: HomeNavigationRouter
    private let horizontalPadding = Layout.size(2)
    
    init(viewModel: VM,
         navigationRouter: HomeNavigationRouter) {
        self.viewModel = viewModel
        self.navigationRouter = navigationRouter
    }
    
    var body: some View {
        viewStateView
            .onAppear {
                viewModel.send(.load, taskPriority: .userInitiated) // Add so a created workout/plan appears after creation
            }
    }
    
    @ViewBuilder
    private var viewStateView: some View {
        switch viewModel.viewState {
        case .error:
            Text("Error!")
        case .loading:
            ProgressView()
        case .main(let display):
            mainView(display: display)
                .onAppear {
                    fabPresenting = false
                }
        }
    }
    
    private func mainView(display: HomeDisplay) -> some View {
        let deletedWorkoutId = deletedWorkoutId(dialog: display.presentedDialog)
        let deletedPlanId = deletedPlanId(dialog: display.presentedDialog)
        
        return ZStack {
            VStack {
                SegmentedControl(selectedIndex: $segmentedControlIndex.animation(), // Putting .animation() here is magic I guess
                                 titles: display.segmentedControlTitles)
                workoutPlanView(display: display)
                Spacer()
            }
            .navigationBar(viewState: display.navBar)
            fabView(state: display.fab)
            // TODO: Maybe add some filters?
        }
        .dialog(isOpen: deletedWorkoutId != nil,
                viewState: display.deleteWorkoutDialog,
                primaryAction: { viewModel.send(.deleteWorkout(id: deletedWorkoutId ?? ""),
                                                taskPriority: .userInitiated) },
                secondaryAction: { viewModel.send(.toggleDialog(type: .deleteWorkout(id: ""),
                                                                isOpen: false),
                                                  taskPriority: .userInitiated) })
        .dialog(isOpen: deletedPlanId != nil,
                viewState: display.deletePlanDialog,
                primaryAction: { viewModel.send(.deletePlan(id: deletedPlanId ?? ""),
                                                taskPriority: .userInitiated) },
                secondaryAction: { viewModel.send(.toggleDialog(type: .deletePlan(id: ""),
                                                                isOpen: false),
                                                  taskPriority: .userInitiated) })
    }
    
    /// Returns the workoutId related to a delete workout dialog
    private func deletedWorkoutId(dialog: HomeDialog?) -> String? {
        if let dialog = dialog,
           case let .deleteWorkout(id) = dialog {
            return id
        } else {
            return nil
        }
    }
    
    private func deletedPlanId(dialog: HomeDialog?) -> String? {
        if let dialog = dialog,
           case let .deletePlan(id) = dialog {
            return id
        } else {
            return nil
        }
    }
    
    @ViewBuilder
    private func workoutPlanView(display: HomeDisplay) -> some View {
        TabView(selection: $segmentedControlIndex) {
            routinesView(routines: display.workouts,
                         tapAction: { navigationRouter.navigate(.seletectWorkout(id: $0.id)) },
                         editAction: { navigationRouter.navigate(.editWorkout(id: $0.id)) },
                         deleteAction: { viewModel.send(.toggleDialog(type: .deleteWorkout(id: $0.id),
                                                                      isOpen: true),
                                                        taskPriority: .userInitiated) })
            .tag(0)
            routinesView(routines: display.plans,
                         tapAction: { navigationRouter.navigate(.selectPlan(id: $0.id)) },
                         editAction: { navigationRouter.navigate(.editPlan(id: $0.id)) },
                         deleteAction: { viewModel.send(.toggleDialog(type: .deletePlan(id: $0.id),
                                                                      isOpen: true),
                                                        taskPriority: .userInitiated) })
            .tag(1)
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
    }
    
    @ViewBuilder
    private func routinesView(routines: [RoutineTileViewState],
                              tapAction: @escaping (RoutineTileViewState) -> Void,
                              editAction: @escaping (RoutineTileViewState) -> Void,
                              deleteAction: @escaping (RoutineTileViewState) -> Void) -> some View {
        if routines.isEmpty {
            emptyRoutinesView
        } else {
            ScrollView(showsIndicators: false) {
                VStack(spacing: Layout.size(1.5)) {
                    ForEach(routines, id: \.self) { viewState in
                        RoutineTile(viewState: viewState,
                                    tapAction: { tapAction(viewState) },
                                    editAction: { editAction(viewState) },
                                    deleteAction: { deleteAction(viewState) })
                    }
                }
                .padding(.horizontal, horizontalPadding)
                .padding(.top, Layout.size(1))
                .padding(.bottom, Layout.size(10)) // Extra padding so FAB doesn't cover the bottom
            }
        }
    }
    
    private var emptyRoutinesView: some View {
        EmojiTitle(emoji: "🏋️‍♂️", title: Strings.getStarted)
            .padding(.bottom, Layout.size(10))
            .padding(.horizontal, horizontalPadding)
    }
    
    @ViewBuilder
    private func fabView(state: HomeFABViewState) -> some View {
        HomeFAB(isPresenting: $fabPresenting,
                viewState: state,
                createPlanAction: { navigationRouter.navigate(.createPlan) },
                createWorkoutAction: { navigationRouter.navigate(.createWorkout) })
    }
}

// MARK: - Strings

fileprivate struct Strings {
    static let getStarted = "Select the plus button below to get started!"
}
