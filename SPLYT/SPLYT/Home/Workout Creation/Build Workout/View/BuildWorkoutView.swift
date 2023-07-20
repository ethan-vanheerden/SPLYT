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

struct BuildWorkoutView<VM: ViewModel>: View where VM.Event == BuildWorkoutViewEvent, VM.ViewState == BuildWorkoutViewState {
    @ObservedObject private var viewModel: VM
    @Environment(\.dismiss) private var dismiss
    @State private var setSheetPresented: Bool = false
    @State private var filterSheetPresented: Bool = false
    @State private var showSetModifiers: Bool = false
    @State private var editExerciseIndex: Int = 0
    @State private var editSetIndex: Int = 0
    @State private var searchText = ""
    private let navigationRouter: BuildWorkoutNavigationRouter
    private let transformer: BuildWorkoutTransformer
    private let horizontalPadding = Layout.size(2)
    
    init(viewModel: VM,
         navigationRouter: BuildWorkoutNavigationRouter,
         transformer: BuildWorkoutTransformer) {
        self.viewModel = viewModel
        self.navigationRouter = navigationRouter
        self.transformer = transformer
        self.viewModel.send(.load, taskPriority: .userInitiated)
    }
    
    var body: some View {
        switch viewModel.viewState {
        case .loading:
            ProgressView()
                .navigationBar(viewState: NavigationBarViewState(title: Strings.addYourExercises)) {
                    viewModel.send(.toggleDialog(type: .leave, isOpen: true),
                                   taskPriority: .userInitiated)
                }
        case .main(let display):
            mainView(display: display)
        case .error:
            Text("Error!")
                .foregroundColor(.red)
                .navigationBar(viewState: NavigationBarViewState(title: Strings.addYourExercises)) {
                    navigationRouter.navigate(.exit)
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
            sheetView(display: display)
        }
        .sheet(isPresented: $filterSheetPresented) {
            filterSheet(display: display.filterDisplay)
        }
        .navigationBar(viewState: NavigationBarViewState(title: Strings.addYourExercises),
                       backAction: { viewModel.send(.toggleDialog(type: .leave, isOpen: true),
                                                    taskPriority: .userInitiated) },
                       content: { saveButton(canSave: display.canSave) })
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
    private func saveButton(canSave: Bool) -> some View {
        IconButton(iconName: "checkmark",
                   style: .secondary,
                   iconColor: .lightBlue,
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
            .padding(.horizontal, horizontalPadding)
        }
        .padding(.horizontal, horizontalPadding)
        .sheet(isPresented: $setSheetPresented) {
            expandedSheetView(display: display)
                .presentationDetents([.fraction(0.75)])
        }
        .onChange(of: setSheetPresented) { baseSheetOpen in
            // Make sure to close the modifier view if we are closing the sheet
            if !baseSheetOpen {
                showSetModifiers = false
            }
        }
        .ignoresSafeArea(.keyboard)
    }
    
    @ViewBuilder
    private func sheetButtons(display: BuildWorkoutDisplay) -> some View {
        HStack(spacing: Layout.size(2)) {
            Spacer()
            SplytButton(text: Strings.editSetsReps) { setSheetPresented = true }
            SplytButton(text: Strings.addGroup,
                        isEnabled: !display.lastGroupEmpty) {
                viewModel.send(.addGroup, taskPriority: .userInitiated)
            }
            Spacer()
        }
    }
    
    @ViewBuilder
    private func expandedSheetView(display: BuildWorkoutDisplay) -> some View {
        ZStack(alignment: .bottom) {
            VStack {
                SegmentedControl(selectedIndex: currentGroupBinding(value: display.currentGroup).animation(),
                                 titles: display.groupTitles)
                currentSetView(display: display)
            }
            setModifiers(currentGroup: display.currentGroup)
                .isVisible(showSetModifiers)
        }
    }
    
    @ViewBuilder
    private func currentSetView(display: BuildWorkoutDisplay) -> some View {
        TabView(selection: currentGroupBinding(value: display.currentGroup).animation()) {
            ForEach(Array(display.groups.enumerated()), id: \.offset) { groupIndex, exercises in
                ScrollView {
                    VStack(spacing: Layout.size(2)) {
                        // Use enumerated here so we can get the exercise index in the group to make updating faster
                        ForEach(Array(exercises.enumerated()), id: \.offset) { exerciseIndex, exerciseState in
                            ExerciseView(
                                viewState: exerciseState,
                                type: .build(
                                    addModifierAction: { setIndex in
                                        // Stores the selected set and exercise for when the modifier is actually added
                                        editSetIndex = setIndex
                                        editExerciseIndex = exerciseIndex
                                        withAnimation {
                                            showSetModifiers = true
                                        }
                                    },
                                    removeModifierAction: { setIndex in
                                        viewModel.send(.removeModifier(group: groupIndex,
                                                                       exerciseIndex: exerciseIndex,
                                                                       setIndex: setIndex),
                                                       taskPriority: .userInitiated)
                                    }),
                                addSetAction: { viewModel.send(.addSet(group: groupIndex),
                                                               taskPriority: .userInitiated) },
                                removeSetAction: { viewModel.send(.removeSet(group: groupIndex),
                                                                  taskPriority: .userInitiated) },
                                updateSetAction: { setIndex, setInput in
                                    viewModel.send(.updateSet(group: groupIndex,
                                                              exerciseIndex: exerciseIndex,
                                                              setIndex: setIndex,
                                                              with: setInput),
                                                   taskPriority: .userInitiated)
                                },
                                updateModifierAction: { setIndex, setInput in
                                    viewModel.send(.updateModifier(group: groupIndex,
                                                                   exerciseIndex: exerciseIndex,
                                                                   setIndex: setIndex,
                                                                   with: setInput),
                                                   taskPriority: .userInitiated)
                                }
                            )
                        }
                    }
                    .padding(.horizontal, Layout.size(2))
                }
                .tag(groupIndex)
            }
            
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
    }
    
    private func currentGroupBinding(value: Int) -> Binding<Int> {
        return Binding(
            get: { return value },
            set: { viewModel.send(.switchGroup(to: $0), taskPriority: .userInitiated) }
        )
    }
    
    @ViewBuilder
    private func setModifiers(currentGroup: Int) -> some View {
        ZStack(alignment: .bottom) {
            Scrim()
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    withAnimation {
                        showSetModifiers = false
                    }
                }
            Tile {
                HStack(spacing: Layout.size(2.5)) {
                    Spacer()
                    ForEach(SetModifierViewState.allCases, id: \.title) { modifier in
                        Tag(viewState: TagFactory.tagFromModifier(modifier: modifier))
                            .onTapGesture {
                                viewModel.send(.addModifier(group: currentGroup,
                                                            exerciseIndex: editExerciseIndex,
                                                            setIndex: editSetIndex,
                                                            modifier: transformer.transformModifier(modifier)),
                                               taskPriority: .userInitiated)
                                showSetModifiers = false
                            }
                    }
                    Spacer()
                }
            }
            .padding(.horizontal, horizontalPadding)
            .scaleEffect(showSetModifiers ? 1 : 0.25)
        }
    }
}

// MARK: - Strings

fileprivate struct Strings {
    static let addYourExercises = "ADD YOUR EXERCISES"
    static let addGroup = "Add group"
    static let editSetsReps = "Edit sets/reps"
    static let noExercisesFound = "No exercises found"
    static let removeFilters = "Remove filters"
    static let favorites = "Favorites"
    static let musclesWorked = "Muscles worked"
    static let filter = "Filter"
}
