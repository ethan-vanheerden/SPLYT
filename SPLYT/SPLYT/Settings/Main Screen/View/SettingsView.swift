//
//  SettingsView.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 7/16/22.
//

import SwiftUI
import Core
import DesignSystem

struct SettingsView<VM: ViewModel>: View where VM.Event == SettingsViewEvent,
                                                VM.ViewState == SettingsViewState {
    @ObservedObject private var viewModel: VM
    private let navigationRouter: SettingsNavigationRouter
    
    init(viewModel: VM,
         navigationRouter: SettingsNavigationRouter) {
        self.viewModel = viewModel
        self.navigationRouter = navigationRouter
        viewModel.send(.load)
    }
    
    var body: some View {
        viewStateView
            .navigationBar(viewState: .init(title: Strings.settings,
                                            size: .large,
                                            position: .left))
    }
    
    @ViewBuilder
    private var viewStateView: some View {
        switch viewModel.viewState {
        case .loading:
            ProgressView()
        case .error:
            Text("Error")
        case .loaded(let display):
            mainView(display: display)
        }
    }
    
    @ViewBuilder
    private func mainView(display: SettingsDisplay) -> some View {
//        List(display.sections, id: \.title) { section in
//            Text(section.title)
//        }
        Text("")
    }
    
//    var body: some View {
//        switch viewModel.viewState {
//        case .loading:
//            ProgressView()
//        case .main(let items):
//            mainView(items: items)
//        }
//    }
//
//    @ViewBuilder
//    private func mainView(items: [MenuItemViewState]) -> some View {
//        VStack {
//            HStack {
//                Text("Settings 🔨")
//                    .largeTitle()
//                Spacer()
//            }
//            .padding(.leading)
//
//            VStack {
//                ForEach(items, id: \.id) {
//                    MenuItem(viewState: $0) { viewState in
//                        navigationRouter.navigate(.menuItem(viewState))
//                    }
//                }
//            }
//            Spacer()
//        }
//    }
}


// MARK: - Strings

fileprivate struct Strings {
    static let settings = "⚙️ Settings"
}
