//
//  MainView.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 7/3/22.
//

import SwiftUI
import DesignSystem

struct MainView<VM: MainViewModelType>: View {
    @ObservedObject private var viewModel: VM
    @State private var selectedTab: TabType = .home
    
    init(viewModel: VM) {
        self.viewModel = viewModel
    }
    
    /// Convenience init for testing different tab selections
    init(viewModel: VM,
         selectedTab: TabType) {
        self.init(viewModel: viewModel)
        self.selectedTab = selectedTab
    }
    
    var body: some View {
        VStack {
            tabView
            TabBar(selectedTab: $selectedTab)
                .padding(.bottom, Layout.size(4))
        }
        .ignoresSafeArea()
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
