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
    private let navigationRouter: HomeNavigationRouter
    
    init(viewModel: VM,
         navigationRouter: HomeNavigationRouter) {
        self.viewModel = viewModel
        self.navigationRouter = navigationRouter
        viewModel.send(.load)
    }
    
    var body: some View {
        switch viewModel.viewState {
        case .error:
            Text("Error!")
        case .loading:
            ProgressView()
        case .main(let display):
            mainView(display: display)
        }
    }
    
    @ViewBuilder
    private func mainView(display: HomeDisplay) -> some View {
        ZStack {
            VStack {
                SegmentedControl(selectedIndex: $segmentedControlIndex.animation(), // Putting .animation() here is magic I guess
                                 titles: display.segmentedControlTitles)
                TabView(selection: $segmentedControlIndex) {
                    Text("workouts").tag(0)
                    Text("plans").tag(1)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                Spacer()
            }
            .navigationBar(state: display.navBar)
            fabView(state: display.fab)
        }
    }
    
    @ViewBuilder
    private func workoutPlanView(display: HomeDisplay) -> some View {
        switch segmentedControlIndex {
        case 0: // Workouts
            
            VStack {
                ForEach(display.workouts, id: \.id) {
                    CreatedWorkoutView(viewState: $0,
                                       tapAction: { _ in }, // TODO
                                       editAction:{ _ in }, // TODO
                                       deleteAction: { _ in }) // TODO
                }
            }
        case 1: // Plans
            Text("Plans")
        default:
            EmptyView()
        }
    }
    
    @ViewBuilder
    private func fabView(state: FABViewState) -> some View {
        FAB(viewState: state,
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
