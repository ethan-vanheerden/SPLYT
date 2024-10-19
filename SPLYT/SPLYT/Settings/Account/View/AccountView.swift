//
//  AccountView.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 10/17/24.
//

import SwiftUI
import Core
import DesignSystem

struct AccountView<VM: ViewModel>: View where VM.Event == AccountViewEvent,
                                                VM.ViewState == AccountViewState {
    @ObservedObject private var viewModel: VM
    @Environment(\.dismiss) private var dismiss
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
            ErrorView(retryAction: { viewModel.send(.load, taskPriority: .userInitiated) },
                      backAction: { dismiss() })
        case .loaded(let display):
            mainView(display: display)
                .dialog(isOpen: display.shownDialog == .signOut,
                        viewState: display.signOutDialog,
                        primaryAction: { viewModel.send(.signOut, taskPriority: .userInitiated) },
                        secondaryAction: { viewModel.send(.toggleDialog(type: .signOut, isOpen: false)) })
                .dialog(isOpen: display.shownDialog == .deleteAccount,
                        viewState: display.deleteAccountDialog,
                        primaryAction: { viewModel.send(.deleteAccount, taskPriority: .userInitiated) },
                        secondaryAction: { viewModel.send(.toggleDialog(type: .deleteAccount, isOpen: false)) })
        }
    }
    
    private func mainView(display: AccountDisplay) -> some View {
        ZStack {
            List {
                ForEach(display.items, id: \.self) { item in
                    accountItemView(for: item)
                }
            }
            if display.isDeleting {
                Group {
                    Scrim()
                    ProgressView()
                }
                .ignoresSafeArea(.all)
                .navigationBarBackButtonHidden()
            }
        }
    }
    
    private func accountItemView(for item: AccountItem) -> some View {
        Button {
            switch item {
            case .signOut:
                viewModel.send(.toggleDialog(type: .signOut, isOpen: true),
                               taskPriority: .userInitiated)
            case .deleteAccount:
                viewModel.send(.toggleDialog(type: .deleteAccount, isOpen: true),
                               taskPriority: .userInitiated)
            }
        } label: {
            SettingsListItem(viewState: .init(title: item.title,
                                              iconName: item.imageName,
                                              iconBackgroundColor: item.backgroundColor))
        }
    }
}
