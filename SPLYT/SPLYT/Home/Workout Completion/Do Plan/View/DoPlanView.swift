//
//  DoPlanView.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 7/4/23.
//

import Foundation
import SwiftUI
import Core
import DesignSystem

struct DoPlanView<VM: ViewModel>: View where VM.Event == DoPlanViewEvent, VM.ViewState == DoPlanViewState {
    @ObservedObject private var viewModel: VM
    private let navigationRouter: DoPlanNavigationRouter
    private let horizontalPadding = Layout.size(2)
    
    init(viewModel: VM,
         navigationRouter: DoPlanNavigationRouter) {
        self.viewModel = viewModel
        self.navigationRouter = navigationRouter
        self.viewModel.send(.load, taskPriority: .userInitiated)
    }
    
    var body: some View {
        switch viewModel.viewState {
        case .error:
            Text("Error!")
        case .loading:
            ProgressView()
        case .loaded(let display):
            mainView(display: display)
        }
    }
    
    @ViewBuilder
    private func mainView(display: DoPlanDisplay) -> some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: Layout.size(1.5)) {
                ForEach(display.workouts, id: \.self) { viewState in
                    RoutineTile(viewState: viewState,
                                tapAction: { navigationRouter.navigate(.doWorkout(workoutId: viewState.id,
                                                                                  historyFilename: viewState.historyFilename)) },
                                editAction: { },
                                deleteAction: { })
                    
                }
            }
            .padding(.horizontal, horizontalPadding)
            .padding(.top, Layout.size(1))
        }
        .navigationBar(viewState: display.navBar,
                       backAction: { navigationRouter.navigate(.exit) })
    }
}
