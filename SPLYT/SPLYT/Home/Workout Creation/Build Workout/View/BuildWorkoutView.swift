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
    @EnvironmentObject private var userTheme: UserTheme
    private let navigationRouter: BuildWorkoutNavigationRouter
    private let type: BuildWorkoutViewType
    private let horizontalPadding = Layout.size(2)
    
    init(viewModel: VM,
         navigationRouter: BuildWorkoutNavigationRouter,
         type: BuildWorkoutViewType = .normal) {
        self.viewModel = viewModel
        self.navigationRouter = navigationRouter
        self.type = type
        self.viewModel.send(.load, taskPriority: .userInitiated)
    }
    
    var body: some View {
        switch viewModel.viewState {
        case .loading:
            ProgressView()
                .navigationBar(viewState: .init(title: type == .replace ? Strings.replaceExercise : Strings.addExercises),
                               backAction: dismissAction)
        case .main(let display), .exitEdit(let display):
            mainView(display: display)
        case .error:
            ErrorView(retryAction: { viewModel.send(.load, taskPriority: .userInitiated) },
                      backAction: dismissAction)
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
                               iconColor: userTheme.theme) {
                        filterSheetPresented = true
                    }
                    if display.isFiltering {
                        Circle()
                            .fill(Color(SplytColor.red))
                            .frame(width: Layout.size(1))
                            .offset(x: Layout.size(0.5), y: Layout.size(0.5))
                        
                    }
                }
                TextEntry(text: $searchText,
                          viewState: TextEntryBuilder.searchEntry(capitalization: .everyWord))
            }
            .padding(.horizontal, horizontalPadding)
            exerciseList(display: display)
            supersetMenu(supersetDisplay: display.supersetDisplay)
        }
        .sheet(isPresented: $filterSheetPresented) {
            filterSheet(display: display.filterDisplay)
        }
        .navigationBar(viewState: .init(title: type == .replace ? Strings.replaceExercise : Strings.addExercises),
                       backAction: dismissAction,
                       content: {
            continueButton(canContinue: display.canSave)
        })
        .dialog(isOpen: display.shownDialog == .leave,
                viewState: display.backDialog,
                primaryAction: { dismiss() },
                secondaryAction: { viewModel.send(.toggleDialog(type: .leave, isOpen: false),
                                                  taskPriority: .userInitiated) })
        .dialog(isOpen: display.shownDialog == .save,
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
                                                useCheckmark: type == .add,
                                                tapAction: addExerciseTileTapAction(exerciseId: exerciseViewState.id,
                                                                                    isCreatingSuperset: display.supersetDisplay.isCreatingSuperset),
                                                favoriteAction: {
                                    viewModel.send(.toggleFavorite(exerciseId: exerciseViewState.id),
                                                   taskPriority: .userInitiated)
                                })
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
                            .background(Color(SplytColor.white))
                        }
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private func emptyExerciseView(isFiltering: Bool) -> some View {
        EmojiTitle(emoji: "😅", title: Strings.noExercisesFound) {
            VStack {
                if isFiltering {
                    SplytButton(text: Strings.removeFilters) {
                        viewModel.send(.removeAllFilters, taskPriority: .userInitiated)
                    }
                }
                SplytButton(text: Strings.createCustomExercise) {
                    navigationRouter.navigate(
                        .createCustomExercise(exerciseName: searchText,
                                              saveAction: { exerciseName in
                                                  viewModel.send(.customExerciseAdded(exerciseName: exerciseName),
                                                                 taskPriority: .userInitiated)
                                                  searchText = exerciseName
                                              })
                    )
                }
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
                    .tint(Color( userTheme.theme))
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
                                    .foregroundColor(Color(SplytColor.black))
                            }
                                                             .toggleStyle(.button)
                                                             .tint(Color( userTheme.theme))
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
                                             iconColor: userTheme.theme, action: { filterSheetPresented = false })})
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
        switch type {
        case .normal:
            SplytButton(text: Strings.next,
                        isEnabled: canContinue) {
                viewModel.send(.nextTapped,
                               taskPriority: .userInitiated)
                navigationRouter.navigate(.editSetsReps)
            }
        case .replace, .add:
            EmptyView()
        }
    }
    
    @ViewBuilder
    private func supersetMenu(supersetDisplay: SupersetDisplay) -> some View {
        switch type {
        case .normal, .add:
            Group {
                if supersetDisplay.isCreatingSuperset {
                    Tile {
                        VStack {
                            Text(supersetDisplay.currentSupersetTitle)
                                .body()
                            HStack(spacing: Layout.size(1)) {
                                SplytButton(text: "Cancel") {
                                    viewModel.send(.cancelSuperset,
                                                   taskPriority: .userInitiated)
                                }
                                SplytButton(text: "Save",
                                            isEnabled: supersetDisplay.canSave) {
                                    if type == .normal {
                                        viewModel.send(.saveSuperset,
                                                       taskPriority: .userInitiated)
                                    } else if type == .add {
                                        navigationRouter.navigate(.addExercises(exerciseIds: supersetDisplay.exerciseIds))
                                    }
                                }
                            }
                        }
                    }
                } else {
                    SplytButton(text: "Create Superset") {
                        viewModel.send(.createSuperset,
                                       taskPriority: .userInitiated)
                    }
                }
            }
            .padding(.horizontal, horizontalPadding)
        case .replace:
            EmptyView()
        }
    }
    
    private var dismissAction: () -> Void {
        switch type {
        case .normal:
            return { viewModel.send(.toggleDialog(type: .leave, isOpen: true),
                                    taskPriority: .userInitiated) }
        case .replace, .add:
            return { navigationRouter.navigate(.dismiss) }
        }
    }
    
    private func addExerciseTileTapAction(exerciseId: String,
                                          isCreatingSuperset: Bool) -> (() -> Void) {
        switch type {
        case .normal:
            return { viewModel.send(.toggleExercise(exerciseId: exerciseId),
                                    taskPriority: .userInitiated) }
        case .replace:
            return { navigationRouter.navigate(.replace(exerciseId: exerciseId)) }
        case .add:
            if isCreatingSuperset {
                return { viewModel.send(.toggleExercise(exerciseId: exerciseId),
                                        taskPriority: .userInitiated) }
            } else {
               return { navigationRouter.navigate(.addExercises(exerciseIds: [exerciseId])) }
            }
        }
    }
}

// MARK: - BuildWorkoutViewType

enum BuildWorkoutViewType {
    case normal
    case replace
    case add
}

// MARK: - Strings

fileprivate struct Strings {
    static let addExercises = "ADD EXERCISES"
    static let addGroup = "Add group"
    static let noExercisesFound = "No exercises found"
    static let removeFilters = "Remove Filters"
    static let favorites = "Favorites"
    static let musclesWorked = "Muscles worked"
    static let filter = "Filter"
    static let next = "Next"
    static let createCustomExercise = "Create Custom Exercise"
    static let replaceExercise = "Replace Exercise"
}
