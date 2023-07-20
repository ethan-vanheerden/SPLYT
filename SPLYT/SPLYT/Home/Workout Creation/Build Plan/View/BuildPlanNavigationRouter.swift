//
//  BuildPlanNavigationRouter.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 6/18/23.
//

import Foundation
import Core
import SwiftUI

// MARK: - Navigation Events

enum BuildPlanNavigationEvent {
    case back
    case exit
    case createNewWorkout
}

// MARK: - Router

final class BuildPlanNavigationRouter: NavigationRouter {
    weak var navigator: Navigator?
    // Has reference so we can save workouts to the plan
    private let viewModel: BuildPlanViewModel
    
    init(viewModel: BuildPlanViewModel) {
        self.viewModel = viewModel
    }
    
    func navigate(_ event: BuildPlanNavigationEvent) {
        switch event {
        case .back:
            handleBack()
        case .exit:
            handleExit()
        case .createNewWorkout:
            handleCreateNewWorkout()
        }
    }
}

// MARK: - Private

private extension BuildPlanNavigationRouter {
    func handleBack() {
        navigator?.pop(animated: true)
    }
    
    func handleExit() {
        navigator?.dismissSelf(animated: true)
    }
    
    func handleCreateNewWorkout() {
        let interactor = NameWorkoutInteractor(buildType: .workout)
        let nameViewModel = NameWorkoutViewModel(interactor: interactor)
        let navRouter = NameWorkoutNavigationRouter() { [weak self] workout in
            // Custom save action to just add the workout to the plan instead of full-saving the workout
            self?.viewModel.send(.addWorkout(workout), taskPriority: .userInitiated)
        }
        let view = NameWorkoutView(viewModel: nameViewModel, navigationRouter: navRouter) { [weak self] in
            self?.navigator?.dismiss(animated: true)
        }
        let navController = UINavigationController(rootViewController: UIHostingController(rootView: view))
        navController.setNavigationBarHidden(true, animated: false)
        navRouter.navigator = navController
        navigator?.present(navController, animated: true)
    }
}
