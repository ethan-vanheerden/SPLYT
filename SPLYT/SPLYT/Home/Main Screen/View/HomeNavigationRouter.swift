//
//  HomeNavigationRouter.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 12/20/22.
//

import Foundation
import Core
import SwiftUI
import ExerciseCore

// MARK: - Navigation Events

enum HomeNavigationEvent {
    case createPlan
    case createWorkout
    case seletectWorkout(id: String)
    case editWorkout(id: String)
    case selectPlan(id: String)
    case editPlan(id: String)
}

// MARK: - Router

final class HomeNavigationRouter: NavigationRouter {
    weak var navigator: Navigator?
    
    func navigate(_ event: HomeNavigationEvent) {
        switch event {
        case .createPlan:
            handleCreate(routineType: .plan)
        case .createWorkout:
            handleCreate(routineType: .workout)
        case let .seletectWorkout(id):
            handleSelectWorkout(id: id)
        case .editWorkout(let id):
            handleEditWorkout(id: id)
        case .selectPlan(let id):
            handleSelectPlan(id: id)
        case .editPlan(let id):
            handleEditPlan(id: id)
        }
    }
}

// MARK: - Private

private extension HomeNavigationRouter {
    
    func handleCreate(routineType: RoutineType) {
        let interactor = NameWorkoutInteractor(routineType: routineType)
        let viewModel = NameWorkoutViewModel(interactor: interactor)
        var navRouter = NameWorkoutNavigationRouter() // var because used as inout parameter
        let view = NameWorkoutView(viewModel: viewModel,
                                   navigationRouter: navRouter) {
            navRouter.navigator?.dismissSelf(animated: true)
        }
        presentNavController(view: view, navRouter: &navRouter)
    }
    
    func handleSelectWorkout(id: String) {
        let interactor = DoWorkoutInteractor(workoutId: id)
        let viewModel = DoWorkoutViewModel(interactor: interactor)
        var navRouter = DoWorkoutNavigationRouter(viewModel: viewModel) { [weak self] in
            self?.navigator?.dismiss(animated: true)
        }
        let view = WorkoutPreviewView(viewModel: viewModel, navigationRouter: navRouter)
        presentNavController(view: view, navRouter: &navRouter)
    }
    
    func handleEditWorkout(id: String) {
        return // TODO
    }
    
    func handleSelectPlan(id: String) {
        let interactor = DoPlanInteractor(planId: id)
        let viewModel = DoPlanViewModel(interactor: interactor)
        var navRouter = DoPlanNavigationRouter(planId: id)
        let view = DoPlanView(viewModel: viewModel, navigationRouter: navRouter)
        presentNavController(view: view, navRouter: &navRouter)
    }
    
    func handleEditPlan(id: String) {
        // TODO
    }
    
    func presentNavController<V: View, N: NavigationRouter>(view: V, navRouter: inout N) {
        // NOTE: this assigns the navigator for the given nav router
        // Use a navigation controller since we will be pushing views on top of a presented view
        let navController = UINavigationController(rootViewController: UIHostingController(rootView: view))
        navController.setNavigationBarHidden(true, animated: false)
        navRouter.navigator = navController
        navigator?.present(navController, animated: true)
    }
}
