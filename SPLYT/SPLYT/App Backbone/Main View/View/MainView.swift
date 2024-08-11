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
    @State private var selectedTab: TabSelection = .home
    @State private var homeViewController = HomeViewController_SwiftUI()
    @State private var historyViewController = HistoryViewController_SwiftUI()
    @State private var settingsViewController = SettingsViewController_SwiftUI()
    private let loginViewModel: LVM
    
    init(viewModel: VM,
         authManager: A,
         loginViewModel: LVM) {
        self.viewModel = viewModel
        self.authManager = authManager
        self.loginViewModel = loginViewModel
        self.viewModel.send(.load, taskPriority: .userInitiated)
    }
    
    var body: some View {
        Group {
            if authManager.isAuthenticated {
                viewStateView
            } else {
                LoginView(viewModel: loginViewModel)
            }
        }
        .onChange(of: authManager.isAuthenticated) { _ in
            // Ensure we go back to home if the user signs back in
            selectedTab = .home
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
    }
    
    @ViewBuilder
    private var mainView: some View {
        VStack(spacing: .zero) {
            tabView
                .animation(nil, value: selectedTab) // Want just the tab to animate, not the actual view change
            TabBar(selectedTab: $selectedTab.animation())
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
