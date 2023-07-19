//
//  BuildPlanView.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 6/18/23.
//

import SwiftUI
import Core
import DesignSystem

struct BuildPlanView<VM: ViewModel>: View where VM.Event == BuildPlanViewEvent, VM.ViewState == BuildPlanViewState {
    @ObservedObject var viewModel: VM
    private let navigationRouter: BuildPlanNavigationRouter
    private let horizontalPadding = Layout.size(2)
    
    init(viewModel: VM,
         navigationRouter: BuildPlanNavigationRouter) {
        self.viewModel = viewModel
        self.navigationRouter = navigationRouter
        self.viewModel.send(.load, taskPriority: .userInitiated)
    }
    
    var body: some View {
        switch viewModel.viewState {
        case .error:
            Text("Error!")
                .navigationBar(viewState: .init(title: Strings.addWorkouts)) { // TODO: get rid of nav bar on error?
                    navigationRouter.navigate(.exit)
                }
        case .loading:
            ProgressView()
        case .loaded(let display):
            mainView(display: display)
        case .exit(let display):
            mainView(display: display)
                .onAppear {
                    navigationRouter.navigate(.exit)
                }
        }
    }
    
    private func mainView(display: BuildPlanDisplay) -> some View {
        let deleteWorkoutId = deleteWorkoutDialogId(display: display)
        
        return VStack {
            if display.workouts.isEmpty {
                emptyWorkoutsView
            } else {
                workoutsList(workouts: display.workouts)
            }
            Spacer()
            addWorkoutButton
        }
        .dialog(isOpen: display.presentedDialog == .back,
                viewState: display.backDialog,
                primaryAction: { navigationRouter.navigate(.exit) },
                secondaryAction: { viewModel.send(.toggleDialog(dialog: .back, isOpen: false),
                                                  taskPriority: .userInitiated) })
        .dialog(isOpen: deleteWorkoutId != nil,
                viewState: display.deleteDialog,
                primaryAction: { viewModel.send(.removeWorkout(workoutId: deleteWorkoutId ?? ""),
                                                taskPriority: .userInitiated) },
                secondaryAction: { viewModel.send(.toggleDialog(dialog: .deleteWorkout(id: ""), isOpen: false),
                                                  taskPriority: .userInitiated) })
        .dialog(isOpen: display.presentedDialog == .save,
                viewState: display.saveDialog,
                primaryAction: { viewModel.send(.savePlan,
                                                taskPriority: .userInitiated) },
                secondaryAction: { viewModel.send(.toggleDialog(dialog: .save, isOpen: false),
                                                  taskPriority: .userInitiated) })
        .navigationBar(viewState: .init(title: Strings.addWorkouts),
                       backAction: { viewModel.send(.toggleDialog(dialog: .back, isOpen: true),
                                                    taskPriority: .userInitiated) },
                       content: { saveButton(canSave: display.canSave) })
    }
    
    private func deleteWorkoutDialogId(display: BuildPlanDisplay) -> String? {
        if let dialog = display.presentedDialog,
           case let .deleteWorkout(id) = dialog {
            return id
        } else {
            return nil
        }
    }
    
    @ViewBuilder
    private var emptyWorkoutsView: some View {
        EmojiTitle(emoji: "💪", title: Strings.noWorkoutsYet)
            .padding(.bottom, Layout.size(10))
            .padding(.horizontal, horizontalPadding)
    }
    
    @ViewBuilder
    private func workoutsList(workouts: [RoutineTileViewState]) -> some View {
        ScrollView {
            VStack(spacing: Layout.size(1.5)) {
                ForEach(workouts, id: \.self) { viewState in
                    RoutineTile(viewState: viewState,
                                tapAction: { },
                                editAction: { }, // TODO: Edit workouts
                                deleteAction: { viewModel.send(.toggleDialog(dialog: .deleteWorkout(id: viewState.id),
                                                                             isOpen: true),
                                                               taskPriority: .userInitiated) })
                    
                }
                .padding(.bottom, Layout.size(1))
            }
            .padding(.horizontal, horizontalPadding)
            .padding(.top, Layout.size(1))
        }
    }
    
    @ViewBuilder
    private var addWorkoutButton: some View {
        SplytButton(text: Strings.addWorkout) {
            navigationRouter.navigate(.createNewWorkout)
        }
        .padding(.horizontal, horizontalPadding)
    }
    
    @ViewBuilder
    private func saveButton(canSave: Bool) -> some View {
        IconButton(iconName: "checkmark",
                   style: .secondary,
                   iconColor: .lightBlue,
                   isEnabled: canSave) {
            viewModel.send(.toggleDialog(dialog: .save, isOpen: true),
                           taskPriority: .userInitiated)
        }
    }
}

// MARK: - Strings

fileprivate struct Strings {
    static let addWorkouts = "Add your workouts"
    static let noWorkoutsYet = "You have no workouts in this plan yet. Select the button below to get started!"
    static let addWorkout = "Add workout"
}
