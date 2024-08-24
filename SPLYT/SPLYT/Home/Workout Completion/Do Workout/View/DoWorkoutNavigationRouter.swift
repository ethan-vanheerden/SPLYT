//
//  DoWorkoutNavigationRouter.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 5/17/23.
//

import Foundation
import Core
import SwiftUI
import DesignSystem

// MARK: - Navigation Events

enum DoWorkoutNavigationEvent {
    case back
    case exit(workoutDetailsId: String? = nil)
    case beginWorkout
    case replaceExercise(replaceAction: (String) -> Void)
    case addExercises(addAction: ([String]) -> Void)
}

// MARK: - Router

final class DoWorkoutNavigationRouter: NavigationRouter {
    weak var navigator: Navigator?
    // Has reference since multiple screens will have this same view model
    private let viewModel: DoWorkoutViewModel
    private let buildWorkoutService: BuildWorkoutServiceType
    private let backAction: () -> Void
    private let exitAction: (String) -> Void // To open the workout details page after finishing a workout
    
    init(viewModel: DoWorkoutViewModel,
         buildWorkoutService: BuildWorkoutServiceType = BuildWorkoutService(),
         backAction: @escaping () -> Void,
         exitAction: @escaping (String) -> Void) {
        self.viewModel = viewModel
        self.buildWorkoutService = buildWorkoutService
        self.backAction = backAction
        self.exitAction = exitAction
    }
    
    func navigate(_ event: DoWorkoutNavigationEvent) {
        switch event {
        case .back:
            handleBack()
        case .exit(let workoutDetailsId):
            handleExit(workoutDetailsId: workoutDetailsId)
        case .beginWorkout:
            handleBeginWorkout()
        case .replaceExercise(let replaceAction):
            handleReplaceExercise(replaceAction: replaceAction)
        case .addExercises(let addAction):
            handleAddExercises(addAction: addAction)
        }
    }
}

// MARK: - Private

private extension DoWorkoutNavigationRouter {
    func handleBack() {
        backAction()
    }
    
    func handleExit(workoutDetailsId: String?) {
        let exitAction = self.exitAction
        
        navigator?.dismissWithCompletion(animated: true) {
            if let workoutDetailsId = workoutDetailsId {
                exitAction(workoutDetailsId)
            }
        }
    }
    
    func handleBeginWorkout() {
        let view = DoWorkoutView(viewModel: viewModel,
                                 navigationRouter: self)
        let vc = ThemedHostingController(rootView: view.withUserTheme())
        self.navigator?.push(vc, animated: false)
    }
    
    func handleReplaceExercise(replaceAction: @escaping (String) -> Void) {
        let interactor = BuildWorkoutInteractor(service: buildWorkoutService,
                                                nameState: .init(name: ""),
                                                saveAction: { _ in })
        let viewModel = BuildWorkoutViewModel(interactor: interactor)
        var navRouter = BuildWorkoutNavigationRouter(viewModel: viewModel,
                                                     replaceExerciseAction: replaceAction)
        navRouter.navigator = navigator
        let view = BuildWorkoutView(viewModel: viewModel, 
                                    navigationRouter: navRouter,
                                    type: .replace).withUserTheme()
        presentNavController(view: view, navRouter: &navRouter)
    }
    
    func handleAddExercises(addAction: @escaping ([String]) -> Void) {
        let interactor = BuildWorkoutInteractor(service: buildWorkoutService,
                                                nameState: .init(name: ""),
                                                saveAction: { _ in })
        let viewModel = BuildWorkoutViewModel(interactor: interactor)
        var navRouter = BuildWorkoutNavigationRouter(viewModel: viewModel,
                                                     addExercisesAction: addAction)
        navRouter.navigator = navigator
        let view = BuildWorkoutView(viewModel: viewModel,
                                    navigationRouter: navRouter,
                                    type: .add).withUserTheme()
        presentNavController(view: view, navRouter: &navRouter)
    }
}
