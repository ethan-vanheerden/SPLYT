//
//  BuildWorkoutView.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 1/10/23.
//

import SwiftUI
import DesignSystem
import Core
import ExerciseCore

struct BuildWorkoutView<VM: ViewModel>: View where VM.Event == BuildWorkoutViewEvent,
                                                    VM.ViewState == BuildWorkoutViewState {
    @ObservedObject private var viewModel: VM
    @Environment(\.dismiss) private var dismiss
    @State private var filterSheetPresented: Bool = false
    @State private var searchText = ""
    private let navigationRouter: BuildWorkoutNavigationRouter
    private let horizontalPadding = Layout.size(2)
    
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
                .navigationBar(viewState: .init(title: Strings.addYourExercises)) {
                    viewModel.send(.toggleDialog(type: .leave, isOpen: true),
                                   taskPriority: .userInitiated)
                }
        case .main(let display):
            mainView(display: display)
        case .error:
            ErrorView(retryAction: { viewModel.send(.load, taskPriority: .userInitiated) },
                      backAction: { navigationRouter.navigate(.exit) })
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
            HStack {
                ZStack(alignment: .topLeading) {
                    IconButton(iconName: "line.3.horizontal.decrease.circle",
                               style: .secondary,
                               iconColor: .lightBlue) {
                        filterSheetPresented = true
                    }
                    if display.isFiltering {
                        Circle()
                            .fill(Color(splytColor: .red))
                            .frame(width: Layout.size(1))
                            .offset(x: Layout.size(0.5), y: Layout.size(0.5))
                        
                    }
                }
                TextEntry(text: $searchText, viewState: TextEntryBuilder.searchEntry)
            }
            .padding(.horizontal, horizontalPadding)
            exerciseList(display: display)
            groupSummary(display: display)
        }
        .sheet(isPresented: $filterSheetPresented) {
            filterSheet(display: display.filterDisplay)
        }
        .navigationBar(viewState: .init(title: Strings.addYourExercises),
                       backAction: { viewModel.send(.toggleDialog(type: .leave, isOpen: true),
                                                    taskPriority: .userInitiated) },
                       content: { continueButton(canContinue: display.canSave) })
        .dialog(isOpen: display.showDialog == .leave,
                viewState: display.backDialog,
                primaryAction: { dismiss() },
                secondaryAction: { viewModel.send(.toggleDialog(type: .leave, isOpen: false),
                                                  taskPriority: .userInitiated) })
        .dialog(isOpen: display.showDialog == .save,
                viewState: display.saveDialog,
                primaryAction: { viewModel.send(.toggleDialog(type: .save, isOpen: false),
                                                taskPriority: .userInitiated) })
        .onChange(of: searchText) { newValue in
            viewModel.send(.filter(by: .search(searchText: newValue)),
                           taskPriority: .userInitiated)
        }
    }
    
    @ViewBuilder
    private func exerciseList(display: BuildWorkoutDisplay) -> some View {
        if display.allExercises.isEmpty {
            emptyExerciseView(isFiltering: display.isFiltering)
        } else {
            ScrollView {
                LazyVStack(pinnedViews: .sectionHeaders) {
                    ForEach(display.allExercises, id: \.self) { viewState in
                        Section {
                            ForEach(viewState.exercises, id: \.self) { exerciseViewState in
                                AddExerciseTile(viewState: exerciseViewState,
                                                tapAction: { viewModel.send(.toggleExercise(exerciseId: exerciseViewState.id),
                                                                            taskPriority: .userInitiated) },
                                                favoriteAction: { viewModel.send(.toggleFavorite(exerciseId: exerciseViewState.id),
                                                                                 taskPriority: .userInitiated) })
                                .padding(.bottom, Layout.size(1))
                            }
                            .padding(.horizontal, horizontalPadding)
                        } header: {
                            HStack {
                                Spacer()
                                SectionHeader(viewState: viewState.header)
                                    .padding(.horizontal, horizontalPadding)
                                    .padding(.vertical, Layout.size(1))
                                Spacer()
                            }
                            .background(Color(splytColor: .white))
                        }
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private func emptyExerciseView(isFiltering: Bool) -> some View {
        EmojiTitle(emoji: "😅", title: Strings.noExercisesFound) {
            if isFiltering {
                SplytButton(text: Strings.removeFilters) {
                    viewModel.send(.removeAllFilters, taskPriority: .userInitiated)
                }
            } else {
                EmptyView()
            }
        }
        .padding(.horizontal, horizontalPadding)
    }
    
    @ViewBuilder
    private func filterSheet(display: BuildWorkoutFilterDisplay) -> some View {
        VStack(spacing: Layout.size(2)) {
            Tile {
                HStack {
                    Toggle(isOn: isFavoriteBinding(isFavorite: display.isFavorite)) {
                        Text(Strings.favorites)
                            .body()
                    }
                    .tint(Color(splytColor: .lightBlue))
                }
            }
            Tile {
                VStack {
                    SectionHeader(viewState: .init(title: Strings.musclesWorked, includeLine: false))
                    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
                    LazyVGrid(columns: columns) {
                        ForEach(MusclesWorked.allCases, id: \.self) { muscle in
                            Toggle(isOn: muscleWorkedBinding(musclesWorked: display.musclesWorked,
                                                             currentMuscle: muscle)) {
                                Text(muscle.rawValue)
                                    .body(style: .medium)
                                    .frame(width: Layout.size(17))
                                    .foregroundColor(Color(splytColor: .black))
                            }
                                                             .toggleStyle(.button)
                                                             .tint(Color(splytColor: .lightBlue))
                        }
                    }
                }
            }
            Spacer()
        }
        .padding(.horizontal, horizontalPadding)
        .padding(.top, Layout.size(2))
        .navigationBar(viewState: .init(title: Strings.filter,
                                        size: .small),
                       content: { IconButton(iconName: "checkmark",
                                             style: .secondary,
                                             iconColor: .lightBlue, action: { filterSheetPresented = false })})
    }
    
    private func isFavoriteBinding(isFavorite: Bool) -> Binding<Bool> {
        return Binding(
            get: { return isFavorite },
            set: { viewModel.send(.filter(by: .favorite(isFavorite: $0)),
                                  taskPriority: .userInitiated) }
        )
    }
    
    private func muscleWorkedBinding(musclesWorked: [MusclesWorked: Bool],
                                     currentMuscle: MusclesWorked) -> Binding<Bool> {
        return Binding(
            get: { return musclesWorked[currentMuscle] ?? false },
            set: { viewModel.send(.filter(by: .muscleWorked(muscle: currentMuscle, isSelected: $0)),
                                  taskPriority: .userInitiated) }
        )
    }
    
    @ViewBuilder
    private func continueButton(canContinue: Bool) -> some View {
        IconButton(iconName: "pencil",
                   style: .secondary,
                   iconColor: .lightBlue,
                   isEnabled: canContinue) {
            navigationRouter.navigate(.editSetsReps)
        }
    }
    
    @ViewBuilder
    private func groupSummary(display: BuildWorkoutDisplay) -> some View {
        Tile {
            VStack {
                Text(display.currentGroupTitle)
                    .body()
                groupButtons(display: display)
            }
            .padding(.horizontal, horizontalPadding)
        }
        .padding(.horizontal, horizontalPadding)
    }
    
    @ViewBuilder
    private func groupButtons(display: BuildWorkoutDisplay) -> some View {
        HStack(spacing: Layout.size(2)) {
            Spacer()
            Menu {
                ForEach(Array(display.groupTitles.enumerated()), id: \.offset) { groupIndex, groupTitle in
                    if display.currentGroup == groupIndex {
                        Button {
                            viewModel.send(.switchGroup(to: groupIndex),
                                           taskPriority: .userInitiated)
                        } label: {
                            Text(groupTitle)
                            Image(systemName: "checkmark")
                        }
                    } else {
                        Button(groupTitle) {
                            viewModel.send(.switchGroup(to: groupIndex),
                                           taskPriority: .userInitiated)
                        }
                    }
                }
            } label: {
                SplytButton(text: display.groupTitles[display.currentGroup]) { }
            }
            SplytButton(text: Strings.addGroup,
                        isEnabled: !display.lastGroupEmpty) {
                viewModel.send(.addGroup, taskPriority: .userInitiated)
            }
            Spacer()
        }
    }
}

// MARK: - Strings

fileprivate struct Strings {
    static let addYourExercises = "ADD YOUR EXERCISES"
    static let addGroup = "Add group"
    static let noExercisesFound = "No exercises found"
    static let removeFilters = "Remove filters"
    static let favorites = "Favorites"
    static let musclesWorked = "Muscles worked"
    static let filter = "Filter"
}
