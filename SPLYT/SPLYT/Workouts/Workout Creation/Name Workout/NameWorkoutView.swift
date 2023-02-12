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
                    .descriptionText()
                Spacer()
            }
            .padding(.leading, Layout.size(2))
            .padding(.top, Layout.size(3))
            
            TextField(Strings.enterAWorkoutName, text: $workoutName)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal, Layout.size(2))
            
            nextButton
            Spacer()
        }
        .navigationBar(state: viewModel.viewState.navBar) { dismissAction() }
    }
    
    private var nextButton: some View {
        HStack {
            Spacer()
            Button(action: {
                navigationRouter.navigate(.next(navigationState))
            }) {
                Text(Strings.next)
                    .descriptionText()
                    .foregroundColor(Color.splytColor(.white))
                    .padding(Layout.size(1.5))
                    .roundedBackground(cornerRadius: Layout.size(1),
                                       fill: Color.splytColor(.lightBlue))
                    .padding(.trailing, Layout.size(2))
            }
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

// MARK: - String Constants

fileprivate struct Strings {
    static let enterAWorkoutName = "Enter a workout name"
    static let workoutName = "Workout Name"
    static let next = "Next"
}
