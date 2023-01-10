//
//  NameWorkoutView.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 1/6/23.
//

import SwiftUI
import DesignSystem
import Core

// TODO: nav bar in Design System
struct NameWorkoutView<VM: ViewModel>: View where VM.Event == NoViewEvent, VM.ViewState == NameWorkoutViewState {
    @Environment(\.dismiss) private var dismiss
    private let viewModel: VM
    private let navigationRouter: NameWorkoutNavigationRouter
    
    init(viewModel: VM,
         navigationRouter: NameWorkoutNavigationRouter) {
        self.viewModel = viewModel
        self.navigationRouter = navigationRouter
    }
    
    var body: some View {
        Text("Hello, World")
            .navigationBar(state: viewModel.viewState.navBar) { dismiss() }
    }
}

struct NameWorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        NameWorkoutView(viewModel: NameWorkoutViewModel(), navigationRouter: NameWorkoutNavigationRouter())
    }
}
