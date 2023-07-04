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
    
    init(viewModel: VM,
         navigationRouter: DoPlanNavigationRouter) {
        self.viewModel = viewModel
        self.navigationRouter = navigationRouter
    }
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}
