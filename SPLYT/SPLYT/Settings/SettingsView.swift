//
//  SettingsView.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 7/16/22.
//

import SwiftUI
import Core
import DesignSystem

struct SettingsView<VM: ViewModel>: View where VM.Event == SettingsViewEvent, VM.ViewState == SettingsViewState {
    @ObservedObject private var viewModel: VM
    private let navigationRouter: SettingsNavigationRouter
    
    init(viewModel: VM,
         navigationRouter: SettingsNavigationRouter) {
        self.viewModel = viewModel
        self.navigationRouter = navigationRouter
        viewModel.send(.load)
    }
    
    let items = ["Design Showcase"]
    
    var body: some View {
        switch viewModel.viewState {
        case .loading:
            ProgressView()
        case .main(let items):
            mainView(items: items)
        }
    }
    
    @ViewBuilder
    private func mainView(items: [MenuItemViewState]) -> some View {
        VStack {
            HStack {
                Text("Settings 🔨")
                    .megaText()
                Spacer()
            }
            .padding(.leading)
            
            VStack {
                ForEach(items) {
                    MenuItem(viewState: $0) { viewState in
                        navigationRouter.navigate(.menuItem(viewState))
                    }
                }
            }
            Spacer()
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(viewModel: SettingsViewModel(),
                     navigationRouter: SettingsNavigationRouter())
    }
}
