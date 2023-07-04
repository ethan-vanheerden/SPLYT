//
//  HomeNavigationRouter.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 12/20/22.
//

import Foundation
import Core
import SwiftUI

// MARK: - Navigation Events

enum HomeNavigationEvent {
    case createPlan
    case createWorkout
    // TODO: ID for a netowork call, filename for a cache call if needed
    case seletectWorkout(id: String, filename: String?)
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
            handleCreate(buildType: .plan)
        case .createWorkout:
            handleCreate(buildType: .workout)
        case let .seletectWorkout(id, filename):
            handleSelectWorkout(id: id, filename: filename)
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
    
    func handleCreate(buildType: BuildWorkoutType) {
        let interactor = NameWorkoutInteractor(buildType: buildType)
        let viewModel = NameWorkoutViewModel(interactor: interactor)
        var navRouter = NameWorkoutNavigationRouter() // var because used as inout parameter
        let view = NameWorkoutView(viewModel: viewModel,
                                   navigationRouter: navRouter) {
            navRouter.navigator?.dismissSelf(animated: true)
        }
        presentNavController(view: view, navRouter: &navRouter)
    }
    
    func handleSelectWorkout(id: String, filename: String?) {
        guard let filename = filename else { return }
        let interactor = DoWorkoutInteractor(workoutId: id, filename: filename)
        let viewModel = DoWorkoutViewModel(interactor: interactor)
        var navRouter = DoWorkoutNavigationRouter(viewModel: viewModel)
        let view = WorkoutPreviewView(viewModel: viewModel, navigationRouter: navRouter)
        presentNavController(view: view, navRouter: &navRouter)
    }
    
    func handleEditWorkout(id: String) {
        return // TODO
    }
    
    func handleSelectPlan(id: String) {
        // TODO: implement
    }
    
    func handleEditPlan(id: String) {
        // TODO
    }
    
    func presentNavController<V: View, N: NavigationRouter>(view: V, navRouter: inout N) {
        // NOTE: this assigned the navigator for the given nav router
        // Use a navigation controller since we will be pushing views on top of a presented view
        let navController = UINavigationController(rootViewController: UIHostingController(rootView: view))
        navController.setNavigationBarHidden(true, animated: false)
        navRouter.navigator = navController
        navigator?.present(navController, animated: true)
    }
}
