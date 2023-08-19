//
//  LoginView.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 8/19/23.
//

import Foundation
import SwiftUI
import Core
import DesignSystem

struct LoginView<VM: ViewModel>: View where VM.Event == LoginViewEvent,
                                                VM.ViewState == LoginViewState {
    @ObservedObject private var viewModel: VM
    private let navigationRouter: LoginNavigationRouter
    private let horizontalPadding = Layout.size(2)
    
    init(viewModel: VM,
         navigationRouter: LoginNavigationRouter) {
        self.viewModel = viewModel
        self.navigationRouter = navigationRouter
        self.viewModel.send(.load, taskPriority: .userInitiated)
    }
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}
