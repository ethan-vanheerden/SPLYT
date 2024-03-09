//
//  LicensesView.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 3/8/24.
//

import SwiftUI
import DesignSystem
import Core

struct LicenseView<VM: ViewModel>: View where VM.Event == LicenseViewEvent,
                                              VM.ViewState == LicenseViewState {
    @ObservedObject private var viewModel: VM
    private let horizontalPadding = Layout.size(2)
    
    init(viewModel: VM) {
        self.viewModel = viewModel
        self.viewModel.send(.load, taskPriority: .userInitiated)
    }
    
    var body: some View {
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
    private func mainView(display: LicenseDisplay) -> some View {
        List {
            ForEach(display.licenses, id: \.self) { license in
                SettingsListItem(viewState: license)
            }
        }
    }
}
