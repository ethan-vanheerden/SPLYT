//
//  NameWorkoutView.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 1/6/23.
//

import SwiftUI
import DesignSystem
import Core

struct NameWorkoutView<VM: ViewModel>: View where VM.Event == NameWorkoutViewEvent,
                                                    VM.ViewState == NameWorkoutViewState {
    @ObservedObject private var viewModel: VM
    private let navigationRouter: NameWorkoutNavigationRouter
    private let dismissAction: () -> Void
    private let horizontalPadding = Layout.size(2)
    
    init(viewModel: VM,
         navigationRouter: NameWorkoutNavigationRouter,
         dismissAction: @escaping () -> Void) {
        self.viewModel = viewModel
        self.navigationRouter = navigationRouter
        self.dismissAction = dismissAction
        self.viewModel.send(.load, taskPriority: .userInitiated)
    }
    
    var body: some View {
        switch viewModel.viewState {
        case .error:
            ErrorView(retryAction: { viewModel.send(.load, taskPriority: .userInitiated) },
                      backAction: dismissAction)
        case .loading:
            ProgressView()
                .navigationBar(viewState: .init(title: ""),
                               backAction: { dismissAction() } )
        case .loaded(let display):
            mainView(display: display)
        }
    }
    
    @ViewBuilder
    private func mainView(display: NameWorkoutDisplay) -> some View {
        VStack {
            TextEntry(text: nameBinding(name: display.workoutName),
                      viewState: display.textEntry)
            nextButton(display: display)
            Spacer()
        }
        .padding(.top, Layout.size(3))
        .padding(.horizontal, horizontalPadding)
        .navigationBar(viewState: display.navBar) { dismissAction() }
    }
    
    @ViewBuilder
    private func nextButton(display: NameWorkoutDisplay) -> some View {
        HStack {
            Spacer()
            SplytButton(text: Strings.next,
                        isEnabled: display.nextButtonEnabled) {
                navigationRouter.navigate(.next(type: display.routineType,
                                                navState: navState(workoutName: display.workoutName)))
                
            }
                .frame(width: Layout.size(10))
        }
    }
    
    private func nameBinding(name: String) -> Binding<String> {
        return Binding(
            get: { return name },
            set: { viewModel.send(.updateWorkoutName(name: $0), taskPriority: .userInitiated) }
        )
    }
    
    private func navState(workoutName: String) -> NameWorkoutNavigationState {
        return NameWorkoutNavigationState(name: workoutName)
    }
}

// MARK: - Strings

fileprivate struct Strings {
    static let next = "Next"
}
