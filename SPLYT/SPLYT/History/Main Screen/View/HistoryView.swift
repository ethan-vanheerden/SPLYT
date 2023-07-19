//
//  HistoryView.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 7/16/22.
//

import SwiftUI
import Core
import DesignSystem

struct HistoryView<VM: ViewModel>: View where VM.Event == HistoryViewEvent, VM.ViewState == HistoryViewState {
    @ObservedObject private var viewModel: VM
    private let navigationRouter: HistoryNavigationRouter
    private let horizontalPadding = Layout.size(2)
    
    init(viewModel: VM,
         navigationRouter: HistoryNavigationRouter) {
        self.viewModel = viewModel
        self.navigationRouter = navigationRouter
        self.viewModel.send(.load, taskPriority: .userInitiated)
    }
    
    var body: some View {
        viewStateView
            .navigationBar(viewState: .init(title: Strings.history,
                                            size: .large,
                                            position: .left))
    }
    
    @ViewBuilder
    var viewStateView: some View {
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
    private func mainView(display: HistoryDisplay) -> some View {
        let deleteWorkoutHistory = deleteWorkoutHistoryInfo(dialog: display.presentedDialog)
        
        VStack {
            workoutsView(workouts: display.workouts)
        }
        .dialog(isOpen: deleteWorkoutHistory != nil,
                viewState: display.deleteWorkoutHistoryDialog,
                primaryAction: { viewModel.send(.deleteWorkoutHistory(workoutId: deleteWorkoutHistory?.0 ?? "",
                                                                      completionDate: deleteWorkoutHistory?.1),
                                                taskPriority: .userInitiated) },
                secondaryAction: { viewModel.send(.toggleDialog(dialog: .deleteWorkoutHistory(workoutId: "",
                                                                                              completionDate: nil),
                                                                isOpen: false),
                                                  taskPriority: .userInitiated) })
    }
    
    private func deleteWorkoutHistoryInfo(dialog: HistoryDialog?) -> (String, Date?)? {
        if let dialog = dialog,
           case let .deleteWorkoutHistory(workoutId, completionDate) = dialog {
            return (workoutId, completionDate)
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
                                    tapAction: { },
                                    deleteAction: { viewModel.send(
                                        .toggleDialog(
                                            dialog: .deleteWorkoutHistory(workoutId: viewState.id,
                                                                          completionDate: viewState.lastCompletedDate),
                                            isOpen: true ),
                                        taskPriority: .userInitiated) })
                    }
                }
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
