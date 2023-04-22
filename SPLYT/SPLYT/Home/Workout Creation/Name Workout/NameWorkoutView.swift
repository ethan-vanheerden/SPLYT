//
//  NameWorkoutView.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 1/6/23.
//

import SwiftUI
import DesignSystem
import Core

struct NameWorkoutView<VM: ViewModel>: View where VM.Event == NoViewEvent, VM.ViewState == NameWorkoutViewState {
    @State private var workoutName = ""
    private let viewModel: VM
    private let navigationRouter: NameWorkoutNavigationRouter
    private let dismissAction: () -> Void
    private let horizontalPadding = Layout.size(2)
    
    init(viewModel: VM,
         navigationRouter: NameWorkoutNavigationRouter,
         dismissAction: @escaping () -> Void) {
        self.viewModel = viewModel
        self.navigationRouter = navigationRouter
        self.dismissAction = dismissAction
    }
    
    var body: some View {
        VStack {
            HStack {
                Text(Strings.workoutName)
                    .body()
                Spacer()
            }
            .padding(.top, Layout.size(3))
            TextField(Strings.enterAWorkoutName, text: $workoutName)
                .textFieldStyle(.roundedBorder)
            nextButton
            Spacer()
        }
        .padding(.horizontal, horizontalPadding)
        .navigationBar(viewState: viewModel.viewState.navBar) { dismissAction() }
    }
    
    private var nextButton: some View {
        HStack {
            Spacer()
            SplytButton(text: Strings.next,
                        isEnabled: !workoutName.isEmpty) { navigationRouter.navigate(.next(navigationState)) }
                .frame(width: Layout.size(10))
        }
    }
    
    private var navigationState: NameWorkoutNavigationState {
        return NameWorkoutNavigationState(workoutName: workoutName)
    }
}

struct NameWorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        NameWorkoutView(viewModel: NameWorkoutViewModel(), navigationRouter: NameWorkoutNavigationRouter()) { }
    }
}

// MARK: - Strings

fileprivate struct Strings {
    static let enterAWorkoutName = "Enter a workout name"
    static let workoutName = "Workout Name"
    static let next = "Next"
}
