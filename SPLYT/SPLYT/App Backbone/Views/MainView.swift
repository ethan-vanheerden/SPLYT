//
//  MainView.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 7/3/22.
//

import SwiftUI

struct MainView<V: MainViewModelType>: View {
    @ObservedObject private var viewModel: V
    @State private var selectedTab: TabType = .workouts
    
    init(viewModel: V) {
        self.viewModel = viewModel
    }
    
    /// Convenience init for testing different tab selections
    init(viewModel: V,
         selectedTab: TabType) {
        self.init(viewModel: viewModel)
        self.selectedTab = selectedTab
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ForEach(TabType.allCases, id: \.self) { tab in
                tabView(tab: tab)
                    .tabItem {
                        Label(tab.title, systemImage: tab.imageName)
                            .tag(tab)
                    }
            }
        }
    }
    
    @ViewBuilder
    // The view to show for each tab
    private func tabView(tab: TabType) -> some View {
        switch tab {
        case .workouts:
            WorkoutsViewController_SwiftUI()
        case .profile:
            ProfileView()
        case .settings:
            SettingsViewController_SwiftUI()
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(viewModel: MainViewModel())
    }
}
