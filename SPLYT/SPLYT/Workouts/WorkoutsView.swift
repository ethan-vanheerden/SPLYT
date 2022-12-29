//
//  WorkoutsView.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 7/16/22.
//

import SwiftUI
import Core
import DesignSystem

struct WorkoutsView<VM: ViewModel>: View where VM.Event == WorkoutsViewEvent, VM.ViewState == WorkoutsViewState {
    @ObservedObject private var viewModel: VM
    private let navigationRouter: WorkoutsNavigationRouter
    
    init(viewModel: VM,
         navigationRouter: WorkoutsNavigationRouter) {
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
    private func mainView(display: WorkoutsDisplayInfo) -> some View {
        ZStack {
            Text("Workouts")
            fabView(state: display.fab)
        }
    }
    
    @ViewBuilder
    private func fabView(state: FABViewState) -> some View {
        FAB(viewState: state,
            createPlanAction: { navigationRouter.navigate(.createPlan) },
            createWorkoutAction: { navigationRouter.navigate(.createWorkout) })
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutsView(viewModel: WorkoutsViewModel(),
                     navigationRouter: WorkoutsNavigationRouter())
    }
}
