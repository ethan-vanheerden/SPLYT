//
//  DoWorkoutView.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 5/17/23.
//

import Foundation
import SwiftUI
import Core
import DesignSystem

struct DoWorkoutView<VM: ViewModel>: View where VM.Event == DoWorkoutViewEvent, VM.ViewState == DoWorkoutViewState {
    @ObservedObject private var viewModel: VM
    @State private var introSeconds: Int = 3
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    private let navigationRouter: DoWorkoutNavigationRouter
    
    init(viewModel: VM,
         navigationRouter: DoWorkoutNavigationRouter) {
        self.viewModel = viewModel
        self.navigationRouter = navigationRouter
    }
    
    var body: some View {
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
    private func mainView(display: DoWorkoutDisplay) -> some View {
        VStack {
            ScrollView(showsIndicators: false) {
                ForEach(Array(display.groups.enumerated()), id: \.offset) { groupIndex, exercises in
                    CollapseHeader(isExpanded: .constant(true),
                                   viewState: .init(title: display.groupTitles[groupIndex],
                                                    color: .lightBlue)) {
                        groupView(exercises: exercises)
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private func groupView(exercises: [ExerciseViewState]) -> some View {
        VStack {
            ForEach(exercises, id: \.self) { exercise in
                ExerciseView(viewState: exercise,
                             type: .inProgress(usePreviousAction: { _ in },
                                               addNoteAction: { }),
                             addSetAction: { },
                             removeSetAction: { },
                             updateSetAction: { _, _ in },
                             updateModifierAction: { _, _ in })
            }
        }
    }
}
