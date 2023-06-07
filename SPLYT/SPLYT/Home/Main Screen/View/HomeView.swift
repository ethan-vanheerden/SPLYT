//
//  HomeView.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 7/16/22.
//

import SwiftUI
import Core
import DesignSystem

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
        let deleteDialogId = deleteDialogId(display: display)
        
        return ZStack {
            VStack {
                SegmentedControl(selectedIndex: $segmentedControlIndex.animation(), // Putting .animation() here is magic I guess
                                 titles: display.segmentedControlTitles)
                workoutPlanView(display: display)
                Spacer()
            }
            .navigationBar(viewState: display.navBar)
            fabView(state: display.fab)
            // TODO: Maybe add a filter button like the Peloton app does?
        }
        .dialog(isOpen: deleteDialogId != nil,
                viewState: display.deleteDialog,
                primaryAction: { viewModel.send(.deleteWorkout(id: deleteDialogId ?? ""), taskPriority: .userInitiated) },
                secondaryAction: { viewModel.send(.toggleDialog(type: .deleteWorkout(id: deleteDialogId ?? ""), isOpen: false),
                                                  taskPriority: .userInitiated) })
    }
    
    private func deleteDialogId(display: HomeDisplay) -> String? {
        if let showDialog = display.showDialog,
           case let .deleteWorkout(id) = showDialog {
            return id
        } else {
            return nil
        }
    }
    
    @ViewBuilder
    private func workoutPlanView(display: HomeDisplay) -> some View {
        TabView(selection: $segmentedControlIndex) {
            workoutsView(workouts: display.workouts)
                .tag(0)
            Text("Plans") // TODO
                .tag(1)
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
    }
    
    @ViewBuilder
    private func workoutsView(workouts: [CreatedWorkoutViewState]) -> some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: Layout.size(1.5)) {
                ForEach(workouts, id: \.id) { viewState in
                    CreatedWorkoutView(viewState: viewState,
                                       tapAction: { navigationRouter.navigate(.seletectWorkout(id: $0)) },
                                       editAction:{ navigationRouter.navigate(.editWorkout(id: $0)) },
                                       deleteAction: { viewModel.send(.toggleDialog(type: .deleteWorkout(id: $0), isOpen: true),
                                                                      taskPriority: .userInitiated) })
                }
            }
            .padding(.horizontal, horizontalPadding)
            .padding(.top, Layout.size(1))
            .padding(.bottom, Layout.size(10)) // Extra padding so FAB doesn't cover the bottom
        }
    }
    
    @ViewBuilder
    private func fabView(state: HomeFABViewState) -> some View {
        HomeFAB(isPresenting: $fabPresenting,
                viewState: state,
                createPlanAction: { navigationRouter.navigate(.createPlan) },
                createWorkoutAction: { navigationRouter.navigate(.createWorkout) })
    }
}

struct WorkoutsView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(viewModel: HomeViewModel(),
                 navigationRouter: HomeNavigationRouter())
    }
}
