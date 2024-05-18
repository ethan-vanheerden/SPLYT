//
//  EditSetsRepsView.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 1/18/24.
//

import Foundation
import SwiftUI
import Core
import DesignSystem
import ExerciseCore

struct EditSetsRepsView<VM: ViewModel>: View where VM.Event == BuildWorkoutViewEvent,
                                                   VM.ViewState == BuildWorkoutViewState {
    @ObservedObject private var viewModel: VM
    @State private var showSetModifiers: Bool = false
    @State private var editGroupIndex: Int = 0
    @State private var editExerciseIndex: Int = 0
    @State private var editSetIndex: Int = 0
    @EnvironmentObject private var userTheme: UserTheme
    private let navigationRouter: BuildWorkoutNavigationRouter
    private let transformer: BuildWorkoutTransformer = .init()
    private let horizontalPadding = Layout.size(2)
    
    init(viewModel: VM,
         navigationRouter: BuildWorkoutNavigationRouter) {
        self.viewModel = viewModel
        self.navigationRouter = navigationRouter
    }
    
    var body: some View {
        switch viewModel.viewState {
        case .loading, .error: // Should never get here
            ErrorView(retryAction: { viewModel.send(.load, taskPriority: .userInitiated) },
                      backAction: { navigationRouter.navigate(.exit) })
        case .main(let display):
            mainView(display: display)
                .navigationBar(viewState: .init(title: Strings.editSetsReps),
                               backAction: {
                    viewModel.send(.backTapped(userInitiated: true),
                                   taskPriority: .userInitiated)
                    navigationRouter.navigate(.goBack)
                },
                               content: { saveButton(canSave: display.canSave) })
        case .exit(let display):
            mainView(display: display)
                .onAppear {
                    navigationRouter.navigate(.exit)
                }
        case .exitEdit(let display):
            mainView(display: display)
                .onAppear {
                    viewModel.send(.backTapped(userInitiated: false),
                                   taskPriority: .userInitiated)
                    navigationRouter.navigate(.goBack)
                }
        }
    }
    
    @ViewBuilder
    private func mainView(display: BuildWorkoutDisplay) -> some View {
        ZStack(alignment: .bottom) {
            exercises(display: display)
            setModifiers
                .isVisible(showSetModifiers)
        }
    }
    
    @ViewBuilder
    private func exercises(display: BuildWorkoutDisplay) -> some View {
        List {
            ForEach(groupsBinding(groups: display.groups), id: \.index, editActions: .move) { $groupTuple in
                let groupIndex = groupTuple.index
                let exercises = groupTuple.exercises
                
                VStack(spacing: Layout.size(2)) {
                    editGroupHeader(groupIndex: groupIndex,
                                    group: exercises,
                                    groupTitles: display.groupTitles)
                    // Use enumerated here so we can get the exercise index in the group to make updating faster
                    ForEach(Array(exercises.enumerated()), id: \.offset) { exerciseIndex, exerciseState in
                        ExerciseView(
                            viewState: exerciseState,
                            type: .build(
                                addModifierAction: { setIndex in
                                    // Stores the selected set and exercise for when the modifier is actually added
                                    editGroupIndex = groupIndex
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
                .padding(horizontalPadding)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(style: StrokeStyle(lineWidth: 2))
                        .foregroundStyle(Color(splytColor: userTheme.theme))
                        .padding(Layout.size(1))
                )
                .listRowSeparator(.hidden)
                .listRowInsets(.init())
                
            }
        }
        .listStyle(.plain)
        .scrollIndicators(.hidden)
    }
    
    @ViewBuilder
    private func editGroupHeader(groupIndex: Int,
                                 group: [ExerciseViewState],
                                 groupTitles: [String]) -> some View {
        HStack {
            Text(groupTitles[groupIndex])
                .title2()
                .foregroundStyle(Color(splytColor: userTheme.theme))
            Spacer()
            IconButton(iconName: "trash", style: .secondary, iconColor: .red50) {
                viewModel.send(.deleteGroup(groupIndex: groupIndex),
                               taskPriority: .userInitiated)
            }
            Image(systemName: "line.3.horizontal")
                .imageScale(.large)
                .foregroundColor(Color(splytColor: userTheme.theme))
            
        }
    }
    
    // Binding to a list of tuples of each group and its group index
    private func groupsBinding(groups: [[ExerciseViewState]]) -> Binding<[(index: Int, exercises: [ExerciseViewState])]> {
        return Binding(
            get: {
                var result = [(index: Int, exercises: [ExerciseViewState])]()
                for (index, group) in groups.enumerated() {
                    result.append((index: index, exercises: group))
                }
                return result
            },
            set: { newGroups in
                let indexOrder = newGroups.map { $0.index }
                viewModel.send(.rearrangeGroups(newOrder: indexOrder),
                               taskPriority: .userInitiated)
            }
        )
    }
    
    @ViewBuilder
    private var setModifiers: some View {
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
                                viewModel.send(.addModifier(group: editGroupIndex,
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
    
    @ViewBuilder
    private func saveButton(canSave: Bool) -> some View {
        SplytButton(text: Strings.save,
                    isEnabled: canSave) {
            viewModel.send(.save, taskPriority: .userInitiated)
        }
    }
}

// MARK: - Strings

fileprivate struct Strings {
    static let editSetsReps = "Edit Sets & Reps"
    static let save = "Save"
}
