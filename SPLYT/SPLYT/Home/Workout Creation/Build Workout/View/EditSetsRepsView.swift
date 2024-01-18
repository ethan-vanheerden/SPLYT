//
//  EditSetsRepsView.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 1/18/24.
//

import Foundation
import SwiftUI
import Core
import DesignSystem

struct EditSetsRepsView<VM: ViewModel>: View where VM.Event == BuildWorkoutViewEvent, 
                                                    VM.ViewState == BuildWorkoutViewState {
    @ObservedObject private var viewModel: VM
    private let navigationRouter: BuildWorkoutNavigationRouter
    private let horizontalPadding = Layout.size(2)
    
    init(viewModel: VM,
         navigationRouter: BuildWorkoutNavigationRouter) {
        self.viewModel = viewModel
        self.navigationRouter = navigationRouter
    }
    
    var body: some View {
        switch viewModel.viewState {
        case .loading, .error, .exit:
            // Should never get here
            Text("Error!")
        case .main(let display):
            mainView(display: display)
                .navigationBar(viewState: .init(title: Strings.editSetsReps),
                               backAction: { navigationRouter.navigate(.goBack)},
                               content: { saveButton(canSave: display.canSave) })
        }
    }
    
    @ViewBuilder
    private func mainView(display: BuildWorkoutDisplay) -> some View {
        Text("Hello World")
    }
    
    @ViewBuilder
    private func saveButton(canSave: Bool) -> some View {
        IconButton(iconName: "checkmark",
                   style: .secondary,
                   iconColor: .lightBlue,
                   isEnabled: canSave) {
            viewModel.send(.save, taskPriority: .userInitiated)
        }
    }
}

// MARK: - Strings

fileprivate struct Strings {
    static let editSetsReps = "Edit Sets & Reps"
}
