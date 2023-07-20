//
//  WorkoutDetailsView.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 7/20/23.
//

import SwiftUI
import DesignSystem
import Core

struct WorkoutDetailsView<VM: ViewModel>: View where VM.Event == WorkoutDetailsViewEvent,
                                                     VM.ViewState == WorkoutDetailsViewState {
    @ObservedObject private var viewModel: VM
    private let navigationRouter: WorkoutDetailsNavigationRouter
    
    init(viewModel: VM,
         navigationRouter: WorkoutDetailsNavigationRouter) {
        self.viewModel = viewModel
        self.navigationRouter = navigationRouter
    }
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}
