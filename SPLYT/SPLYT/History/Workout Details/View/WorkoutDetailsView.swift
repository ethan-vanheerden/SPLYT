//
//  WorkoutDetailsView.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 7/20/23.
//

import SwiftUI
import DesignSystem
import Core

struct WorkoutDetailsView<VM: ViewModel>: View where VM.Event == WorkoutDetailsViewEvent,
                                                     VM.ViewState == WorkoutDetailsViewState {
    @ObservedObject private var viewModel: VM
    @State private var optionsSheetPresented = false
    private let navigationRouter: WorkoutDetailsNavigationRouter
    private let horizontalPadding = Layout.size(2)
    
    init(viewModel: VM,
         navigationRouter: WorkoutDetailsNavigationRouter) {
        self.viewModel = viewModel
        self.navigationRouter = navigationRouter
        self.viewModel.send(.load, taskPriority: .userInitiated)
    }
    
    var body: some View {
        viewStateView
            .navigationBar(viewState: .init(title: Strings.workoutDetails),
                           backAction: { navigationRouter.navigate(.exit) },
                           content: { optionsButton })
    }
    
    @ViewBuilder
    var viewStateView: some View {
        switch viewModel.viewState {
        case .loading:
            ProgressView()
        case .error:
            Text("Error!")
        case .loaded(let display):
            mainView(display: display)
        case .exit(let display):
            mainView(display: display)
                .onAppear {
                    navigationRouter.navigate(.exit)
                }
        }
    }
    
    @ViewBuilder
    private func mainView(display: WorkoutDetailsDisplay) -> some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading) {
                header(display: display)
                    .padding(.bottom, Layout.size(1.5))
                groupsView(display: display)
            }
            .padding(.horizontal, horizontalPadding)
        }
        .animation(.default, value: display.expandedGroups)
        .confirmationDialog("", isPresented: $optionsSheetPresented, titleVisibility: .hidden) {
            Button(Strings.delete, role: .destructive) {
                viewModel.send(.toggleDialog(dialog: .delete, isOpen: true),
                               taskPriority: .userInitiated)
            }
        }
        .dialog(isOpen: display.presentedDialog == .delete,
                viewState: display.deleteDialog,
                primaryAction: { viewModel.send(.delete,
                                                taskPriority: .userInitiated) },
                secondaryAction: { viewModel.send(.toggleDialog(dialog: .delete, isOpen: false),
                                                  taskPriority: .userInitiated) })
    
    }
    
    @ViewBuilder
    private func header(display: WorkoutDetailsDisplay) -> some View {
        VStack(alignment: .leading) {
            Text(display.workoutName)
                .title1()
                .foregroundColor(Color(splytColor: .black))
            Text(display.numExercisesTitle)
                .title2()
                .foregroundColor(Color(splytColor: .lightBlue))
            Text(display.completedTitle)
                .title3()
                .foregroundColor(Color(splytColor: .gray))
        }
    }
    
    @ViewBuilder
    private func groupsView(display: WorkoutDetailsDisplay) -> some View {
        VStack {
            ForEach(Array(display.groups.enumerated()), id: \.element) { groupIndex, groupState in
                CompletedExerciseGroupView(isExpanded: groupExpandBinding(group: groupIndex,
                                                                          expandedGroups: display.expandedGroups),
                                           viewState: groupState)
            }
        }
    }
    
    private func groupExpandBinding(group: Int, expandedGroups: [Bool]) -> Binding<Bool> {
        return Binding(
            get: { return expandedGroups[group] },
            set: { viewModel.send(.toggleGroupExpand(group: group, isExpanded: $0),
                                  taskPriority: .userInitiated) }
        )
    }
    
    private var optionsButton: some View {
        IconButton(iconName: "ellipsis",
                   style: .secondary,
                   iconColor: .black) {
            optionsSheetPresented = true
        }
    }
}

// MARK: - Strings

fileprivate struct Strings {
    static let workoutDetails = "Workout Details"
    static let delete = "Delete"
}
