//
//  CustomExerciseView.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 5/22/24.
//

import SwiftUI
import Core
import DesignSystem
import ExerciseCore

struct CustomExerciseView<VM: ViewModel>: View where VM.Event == CustomExerciseViewEvent,
                                                     VM.ViewState == CustomExerciseViewState {
    @ObservedObject private var viewModel: VM
    @EnvironmentObject private var userTheme: UserTheme
    private let navigationRouter: CustomExerciseNavigationRouter
    private let horizontalPadding = Layout.size(2)
    private let musclesWorkedColumns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    
    init(viewModel: VM,
         navigationRouter: CustomExerciseNavigationRouter) {
        self.viewModel = viewModel
        self.navigationRouter = navigationRouter
        self.viewModel.send(.load, taskPriority: .userInitiated)
    }
    
    var body: some View {
        viewStateView
            .navigationBar(viewState: .init(title: Strings.createCustomExercise),
                           backAction: { navigationRouter.navigate(.exit) })
    }
    
    @ViewBuilder
    private var viewStateView: some View {
        switch viewModel.viewState {
        case .loading:
            ProgressView()
        case .error:
            ErrorView(retryAction: { viewModel.send(.load, taskPriority: .userInitiated) },
                      backAction: { navigationRouter.navigate(.exit) })
        case .loaded(let display):
            mainView(display: display)
        case .exit(let display):
            mainView(display: display)
                .onAppear {
                    navigationRouter.navigate(.save(exerciseName: display.exerciseName))
                }
        }
    }
    
    @ViewBuilder
    private func mainView(display: CustomExerciseDisplay) -> some View {
        VStack {
            textEntry(display: display)
                .padding(.bottom, Layout.size(2))
            musclesWorked(display: display)
            Spacer()
            if display.isSaving {
                SplytButton(text: "",
                            type: .loading(),
                            isEnabled: false) { }
            } else {
                SplytButton(text: Strings.save) {
                    viewModel.send(.submit, taskPriority: .userInitiated)
                    viewModel.send(.save, taskPriority: .userInitiated)
                }
            }
        }
        .padding(.top, Layout.size(2))
        .padding(.horizontal, horizontalPadding)
    }
    
    @ViewBuilder
    private func textEntry(display: CustomExerciseDisplay) -> some View {
        TextEntry(text: exerciseNameBinding(name: display.exerciseName),
                  viewState: display.exerciseNameEntry)
    }
    
    @ViewBuilder
    private func musclesWorked(display: CustomExerciseDisplay) -> some View {
        VStack {
            SectionHeader(viewState: display.musclesWorkedHeader)
            Tile {
                LazyVGrid(columns: musclesWorkedColumns) {
                    ForEach(MusclesWorked.allCases, id: \.self) { muscle in
                        Toggle(isOn: muscleWorkedBinding(musclesWorked: display.musclesWorked,
                                                         currentMuscle: muscle)) {
                            Text(muscle.rawValue)
                                .body(style: .medium)
                                .frame(width: Layout.size(17))
                                .foregroundColor(Color(SplytColor.label))
                        }
                                                         .toggleStyle(.button)
                                                         .tint(Color(userTheme.theme))
                    }
                }
            }
        }
    }
    
    private func exerciseNameBinding(name: String) -> Binding<String> {
        return Binding(
            get: { return name },
            set: { viewModel.send(.updateExerciseName(to: $0),
                                  taskPriority: .userInitiated) }
        )
    }
    
    private func muscleWorkedBinding(musclesWorked: [MusclesWorked: Bool],
                                     currentMuscle: MusclesWorked) -> Binding<Bool> {
        return Binding(
            get: { return musclesWorked[currentMuscle] ?? false },
            set: { viewModel.send(.updateMuscleWorked(muscle: currentMuscle, isSelected: $0),
                                  taskPriority: .userInitiated) }
        )
    }
}

// MARK: - Strings

fileprivate struct Strings {
    static let createCustomExercise = "Custom Exercise"
    static let save = "Save"
}
