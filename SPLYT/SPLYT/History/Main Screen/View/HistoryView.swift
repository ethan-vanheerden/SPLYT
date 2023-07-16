//
//  HistoryView.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 7/16/22.
//

import SwiftUI
import Core

struct HistoryView<VM: ViewModel>: View where VM.Event == HistoryViewEvent, VM.ViewState == HistoryViewState {
    @ObservedObject private var viewModel: VM
    private let navigationRouter: HistoryNavigationRouter
    
    init(viewModel: VM,
         navigationRouter: HistoryNavigationRouter) {
        self.viewModel = viewModel
        self.navigationRouter = navigationRouter
    }
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}
