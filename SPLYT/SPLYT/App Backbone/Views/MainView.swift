//
//  MainView.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 7/3/22.
//

import SwiftUI

struct MainView<V: MainViewModelType>: View {
    @ObservedObject private var viewModel: V
    
    init(viewModel: V) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        TabView {
            ForEach(TabType.allCases, id: \.self) { tab in
                tab.baseView
                    .tabItem {
                        Label(tab.title, systemImage: tab.imageName)
                            .tag(tab)
                    }
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(viewModel: MainViewModel())
    }
}
