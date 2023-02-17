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
    
    init(viewModel: VM) {
        self.viewModel = viewModel
        self.viewModel.send(.load, taskPriority: .userInitiated)
    }
    
    var body: some View {
        baseView
            .navigationBar(state: NavigationBarViewState(title: Strings.addYourExercises)) {
                dismiss()
            }
    }
    
    @ViewBuilder
    private var baseView: some View {
        switch viewModel.viewState {
        case .loading:
            ProgressView()
        case .main(let display):
            mainView(display: display)
        case .error:
            Text("Error!")
                .foregroundColor(.red)
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
    }
    
    @ViewBuilder
    private func sheetView(display: BuildWorkoutDisplay) -> some View {
        Tile {
            VStack {
                HStack {
                    Text(display.currentGroupTitle)
                        .subhead()
                    Spacer()
                    Button(action: {
                        viewModel.send(.addGroup, taskPriority: .userInitiated)
                    }) {
                        Text(Strings.addGroup)
                            .footnote()
                            .foregroundColor(Color.splytColor(.white))
                            .padding(Layout.size(1))
                            .roundedBackground(cornerRadius: Layout.size(1), fill: Color.splytColor(.lightBlue))
                            .padding(ViewConstants.horizontalPadding)
                    }
                }
                Button(Strings.editSetsReps) {
                    sheetPresented.toggle()
                }
            }
            .padding(.horizontal, ViewConstants.horizontalPadding)
        }
        .padding(.horizontal, ViewConstants.horizontalPadding)
        .sheet(isPresented: $sheetPresented) {
            expandedSheetView(display: display)
                .presentationDetents([.fraction(0.75)])
        }
    }
    
    private func expandedSheetView(display: BuildWorkoutDisplay) -> some View {
        return VStack {
            SegmentedControl(selectedIndex: currentGroupBinding(value: display.currentGroup),
                             titles: display.groupTitles)
            currentSetView(display: display)
        }
    }
    
    private func currentSetView(display: BuildWorkoutDisplay) -> some View {
        let currentGroup = display.currentGroup
        return ScrollView {
            VStack(spacing: Layout.size(2)) {
                ForEach(display.groups[currentGroup], id: \.id) { state in
                    BuildExerciseView(viewState: state,
                                      addSetAction: { viewModel.send(.addSet(group: currentGroup), taskPriority: .userInitiated) },
                                      removeSetAction: { viewModel.send(.removeSet(group: currentGroup)) },
                                      addModiferAction: { /* TODO */ },
                                      updateAction: { _, _ in /* TODO: SPLYT-31 */ })
                }
            }
        }
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
}

// MARK: - View Constants

fileprivate struct ViewConstants {
    static let horizontalPadding = Layout.size(2)
}
