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
    
    init(viewModel: VM) {
        self.viewModel = viewModel
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
        Form {
            ForEach(display.sections, id: \.self) { section in
                if section.isEnabled {
                    Section {
                        detail(items: section.items)
                    } header: {
                        Text(section.title)
                            .subhead()
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func detail(items: [SettingsItem]) -> some View {
        ForEach(items, id: \.self) { item in
            if item.isEnabled {
                switch item.detail {
                case .navigation:
                    navigationDetail(item: item)
                case .link(let url):
                    linkDetail(item: item, url: url)
                case .button:
                    buttonDetail(item: item)
                }
            }
        }
    }
    
    @ViewBuilder
    private func navigationDetail(item: SettingsItem) -> some View {
        NavigationLink {
            SettingsViewFactory().makeView(item)
                .navigationBar(viewState: .init(title: item.title))
        } label: {
            detailLabel(item: item)
        }
    }
    
    @ViewBuilder
    private func linkDetail(item: SettingsItem, url: String) -> some View {
        if let url = URL(string: url) {
            Link(destination: url) {
                detailLabel(item: item)
            }
        }
    }
    
    @ViewBuilder
    private func buttonDetail(item: SettingsItem) -> some View {
        Button {
            switch item {
            case .signOut:
                viewModel.send(.signOut, taskPriority: .userInitiated)
            default:
                return
            }
        } label: {
            detailLabel(item: item)
        }

    }
    
    @ViewBuilder
    private func detailLabel(item: SettingsItem) -> some View {
        HStack {
            IconImage(imageName: item.imageName,
                      backgroundColor: item.backgroundColor)
            Text(item.title)
                .subhead(style: .semiBold)
                .foregroundColor(Color(splytColor: .black))
            Spacer()
        }
    }
}

// MARK: - Strings

fileprivate struct Strings {
    static let settings = "⚙️ Settings"
}
