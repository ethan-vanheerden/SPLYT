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
        Text("Workouts")
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutsView(viewModel: WorkoutsViewModel(),
                     navigationRouter: WorkoutsNavigationRouter())
    }
}
