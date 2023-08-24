//
//  MainView.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 7/3/22.
//

import SwiftUI
import DesignSystem
import Core

struct MainView<VM: ViewModel, LVM: ViewModel, A: AuthManagerType>: View where VM.ViewState == MainViewState,
                                                                               VM.Event == MainViewEvent,
                                                                               LVM.ViewState == LoginViewState,
                                                                               LVM.Event == LoginViewEvent {
    @ObservedObject private var viewModel: VM
    @ObservedObject private var authManager: A
    private let loginViewModel: LVM
    @State private var selectedTab: TabType = .home
    private let navigationRouter: MainViewNavigationRouter
    
    init(viewModel: VM,
         authManager: A,
         loginViewModel: LVM,
         navigationRouter: MainViewNavigationRouter) {
        self.viewModel = viewModel
        self.authManager = authManager
        self.loginViewModel = loginViewModel
        self.navigationRouter = navigationRouter
        self.viewModel.send(.load, taskPriority: .userInitiated)
    }
    
    /// Convenience init for testing different tab selections
    init(viewModel: VM,
         authManager: A,
         loginViewModel: LVM,
         navigationRouter: MainViewNavigationRouter,
         selectedTab: TabType) {
        self.init(viewModel: viewModel,
                  authManager: authManager,
                  loginViewModel: loginViewModel,
                  navigationRouter: navigationRouter)
        self.selectedTab = selectedTab
        self.viewModel.send(.load, taskPriority: .userInitiated)
    }
    
    var body: some View {
        if authManager.isAuthenticated {
            viewStateView
        } else {
            LoginView(viewModel: loginViewModel)
        }
    }
    
    @ViewBuilder
    private var viewStateView: some View {
        Group {
            switch viewModel.viewState {
            case .loading:
                ProgressView()
            case .loaded:
                mainView
            }
        }
        .ignoresSafeArea()
        .preferredColorScheme(.light)
        .colorScheme(.light)
    }
    
    @ViewBuilder
    private var mainView: some View {
        VStack {
            tabView
            TabBar(selectedTab: $selectedTab)
                .padding(.bottom, Layout.size(4))
        }
    }
    
    @ViewBuilder
    /// The view to show for the selected tab.
    /// We have these visibility modifiers so the view doesn't refresh every time we choose a tab.
    private var tabView: some View {
        ZStack {
            HomeViewController_SwiftUI()
                .isVisible(selectedTab == .home)
            HistoryViewController_SwiftUI()
                .isVisible(selectedTab == .history)
            SettingsViewController_SwiftUI()
                .isVisible(selectedTab == .settings)
        }
    }
}
