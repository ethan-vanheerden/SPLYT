//
//  BuildWorkoutView.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 1/10/23.
//

import SwiftUI
import DesignSystem
import Core

struct BuildWorkoutView<VM: ViewModel>: View where VM.Event == BuildWorkoutViewEvent, VM.ViewState == BuildWorkoutViewState {
    @ObservedObject private var viewModel: VM
    @Environment(\.dismiss) private var dismiss
    @State private var sheetPresented: Bool = false
    private let navigationRouter: BuildWorkoutNavigationRouter
    
    init(viewModel: VM,
         navigationRouter: BuildWorkoutNavigationRouter) {
        self.viewModel = viewModel
        self.navigationRouter = navigationRouter
        self.viewModel.send(.load, taskPriority: .userInitiated)
    }
    
    var body: some View {
        switch viewModel.viewState {
        case .loading:
            ProgressView()
                .navigationBar(viewState: NavigationBarViewState(title: Strings.addYourExercises)) {
                    viewModel.send(.toggleDialog(type: .leave, isOpen: true), taskPriority: .userInitiated)
                }
        case .main(let display):
            mainView(display: display)
        case .error:
            Text("Error!")
                .foregroundColor(.red)
                .navigationBar(viewState: NavigationBarViewState(title: Strings.addYourExercises)) {
                    viewModel.send(.toggleDialog(type: .leave, isOpen: true), taskPriority: .userInitiated)
                }
        case .exit(let display):
            mainView(display: display)
                .onAppear {
                    navigationRouter.navigate(.exit)
                }
        }
    }
    
    @ViewBuilder
    private func mainView(display: BuildWorkoutDisplay) -> some View {
        VStack {
            ScrollView {
                LazyVStack {
                    ForEach(display.allExercises, id: \.id) { viewState in
                        AddExerciseTile(viewState: viewState,
                                        tapAction: { viewModel.send(.toggleExercise(id: viewState.id, group: display.currentGroup),
                                                                    taskPriority: .userInitiated) },
                                        favoriteAction: { viewModel.send(.toggleFavorite(id: viewState.id),
                                                                         taskPriority: .userInitiated) })
                    }
                }
                .padding(ViewConstants.horizontalPadding)
            }
            sheetView(display: display)
        }
        .navigationBar(viewState: NavigationBarViewState(title: Strings.addYourExercises),
                       backAction: { viewModel.send(.toggleDialog(type: .leave, isOpen: true), taskPriority: .userInitiated) }) {
            saveButton(canSave: display.canSave)
        }
                       .dialog(isOpen: display.showDialog == .leave,
                               viewState: display.backDialog,
                               primaryAction: { dismiss() },
                               secondaryAction: { viewModel.send(.toggleDialog(type: .leave, isOpen: false), taskPriority: .userInitiated) })
                       .dialog(isOpen: display.showDialog == .save,
                               viewState: display.saveDialog,
                               primaryAction: { viewModel.send(.toggleDialog(type: .save, isOpen: false), taskPriority: .userInitiated) })
    }
    
    @ViewBuilder
    private func saveButton(canSave: Bool) -> some View {
        SplytButton(text: Strings.save,
                    size: .secondary,
                    isEnabled: canSave) {
            viewModel.send(.save, taskPriority: .userInitiated)
        }
    }
    
    @ViewBuilder
    private func sheetView(display: BuildWorkoutDisplay) -> some View {
        Tile {
            VStack {
                Text(display.currentGroupTitle)
                    .body()
                sheetButtons(display: display)
            }
            .padding(.horizontal, ViewConstants.horizontalPadding)
        }
        .padding(.horizontal, ViewConstants.horizontalPadding)
        .sheet(isPresented: $sheetPresented) {
            expandedSheetView(display: display)
                .presentationDetents([.fraction(0.75)])
        }
    }
    
    @ViewBuilder
    private func sheetButtons(display: BuildWorkoutDisplay) -> some View {
        HStack(spacing: Layout.size(2)) {
            Spacer()
            SplytButton(text: Strings.editSetsReps) { sheetPresented.toggle() }
            SplytButton(text: Strings.addGroup,
                        isEnabled: !display.lastGroupEmpty) {
                viewModel.send(.addGroup, taskPriority: .userInitiated)
            }
            Spacer()
        }
    }
    
    private func expandedSheetView(display: BuildWorkoutDisplay) -> some View {
        return VStack {
            SegmentedControl(selectedIndex: currentGroupBinding(value: display.currentGroup).animation(),
                             titles: display.groupTitles)
            currentSetView(display: display)
        }
    }
    
    private func currentSetView(display: BuildWorkoutDisplay) -> some View {
        
        return TabView(selection: currentGroupBinding(value: display.currentGroup).animation()) {
            ForEach(Array(display.groups.enumerated()), id: \.offset) { groupIndex, exercises in
                ScrollView {
                    VStack(spacing: Layout.size(2)) {
                        // Use enumerated here so we can get the exercise index in the group to make updating faster
                        ForEach(Array(exercises.enumerated()), id: \.offset) { exerciseIndex, exerciseState in
                            BuildExerciseView(viewState: exerciseState,
                                              addSetAction: { viewModel.send(.addSet(group: groupIndex), taskPriority: .userInitiated) },
                                              removeSetAction: { viewModel.send(.removeSet(group: groupIndex)) },
                                              addModiferAction: { /* TODO */ },
                                              updateAction: { id, setInput in
                                viewModel.send(.updateSet(id: id,
                                                          group: groupIndex,
                                                          exerciseIndex: exerciseIndex,
                                                          with: setInput),
                                               taskPriority: .userInitiated)
                            })
                        }
                    }
                }
                .tag(groupIndex)
            }
            
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
    }
    
    private func currentGroupBinding(value: Int) -> Binding<Int> {
        return Binding(
            get: { return value },
            set: { viewModel.send(.switchGroup(to: $0), taskPriority: .userInitiated) })
    }
}

// MARK: - String Constants

fileprivate struct Strings {
    static let addYourExercises = "ADD YOUR EXERCISES"
    static let addGroup = "Add group"
    static let editSetsReps = "Edit sets/reps"
    static let save = "SAVE"
}

// MARK: - View Constants

fileprivate struct ViewConstants {
    static let horizontalPadding = Layout.size(2)
}
