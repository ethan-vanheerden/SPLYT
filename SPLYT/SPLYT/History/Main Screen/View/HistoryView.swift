//
//  HistoryView.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 7/16/22.
//

import SwiftUI
import Core
import DesignSystem

struct HistoryView<VM: ViewModel>: View where VM.Event == HistoryViewEvent,
                                              VM.ViewState == HistoryViewState {
    @ObservedObject private var viewModel: VM
    private let navigationRouter: HistoryNavigationRouter
    private let horizontalPadding = Layout.size(2)
    
    init(viewModel: VM,
         navigationRouter: HistoryNavigationRouter) {
        self.viewModel = viewModel
        self.navigationRouter = navigationRouter
    }
    
    var body: some View {
        viewStateView
            .navigationBar(viewState: .init(title: Strings.history,
                                            size: .large,
                                            position: .left))
            .onAppear {
                viewModel.send(.load, taskPriority: .userInitiated)
            }
    }
    
    @ViewBuilder
    private var viewStateView: some View {
        switch viewModel.viewState {
        case .loading:
            ProgressView()
        case .error:
            ErrorView(retryAction: { viewModel.send(.load, taskPriority: .userInitiated) })
        case .loaded(let display):
            mainView(display: display)
        }
    }
    
    @ViewBuilder
    private func mainView(display: HistoryDisplay) -> some View {
        let deleteHistoryId = deletedHistoryId(dialog: display.presentedDialog)
        
        VStack {
            workoutsView(workouts: display.workouts)
        }
        .dialog(isOpen: deleteHistoryId != nil,
                viewState: display.deleteWorkoutHistoryDialog,
                primaryAction: { viewModel.send(.deleteWorkoutHistory(historyId: deleteHistoryId ?? ""),
                                                taskPriority: .userInitiated) },
                secondaryAction: { viewModel.send(.toggleDialog(dialog: .deleteWorkoutHistory(historyId: ""),
                                                                isOpen: false),
                                                  taskPriority: .userInitiated) })
    }
    
    /// Returns the historyId releated to a delete history dialog
    private func deletedHistoryId(dialog: HistoryDialog?) -> String? {
        if let dialog = dialog,
           case .deleteWorkoutHistory(let historyId) = dialog {
            return historyId
        } else {
            return nil
        }
    }
    
    @ViewBuilder
    private func workoutsView(workouts: [RoutineTileViewState]) -> some View {
        if workouts.isEmpty {
            emptyWorkoutsView
        } else {
            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: Layout.size(1.5)) {
                    ForEach(workouts, id: \.self) { viewState in
                        RoutineTile(viewState: viewState,
                                    tapAction: { navigationRouter.navigate(
                                        .selectWorkoutHistory(historyId: viewState.id)) },
                                    deleteAction: { viewModel.send(
                                        .toggleDialog(dialog: .deleteWorkoutHistory(historyId: viewState.id),
                                                      isOpen: true ),
                                        taskPriority: .userInitiated) })
                    }
                }
                .padding(.top, Layout.size(2))
                .padding(.horizontal, horizontalPadding)
            }
        }
    }
    
    @ViewBuilder
    private var emptyWorkoutsView: some View {
        EmojiTitle(emoji: "📊", title: Strings.noWorkoutsYet)
            .padding(.horizontal, horizontalPadding)
    }
}

// MARK: - Strings

fileprivate struct Strings {
    static let history = "📓 History"
    static let noWorkoutsYet = "Workouts you have completed will appear here!"
}
