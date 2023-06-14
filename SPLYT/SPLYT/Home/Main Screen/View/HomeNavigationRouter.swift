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
    case seletectWorkout(id: String, filename: String)
    case editWorkout(id: String)
}

// MARK: - Router

final class HomeNavigationRouter: NavigationRouter {
    weak var navigator: Navigator?
    
    func navigate(_ event: HomeNavigationEvent) {
        switch event {
        case .createPlan:
            handleCreatePlan()
        case .createWorkout:
            handleCreateWorkout()
        case let .seletectWorkout(id, filename):
            handleSelectWorkout(id: id, filename: filename)
        case .editWorkout(let id):
            handleEditWorkout(id: id)
        }
    }
}

// MARK: - Private

private extension HomeNavigationRouter {
    func handleCreatePlan() {
        let view = Text("CREATE PLAN")
        navigator?.present(UIHostingController(rootView: view), animated: true)

    }
    
    func handleCreateWorkout() {
        let viewModel = NameWorkoutViewModel()
        var navRouter = NameWorkoutNavigationRouter() // var because used as inout parameter
        let view = NameWorkoutView(viewModel: viewModel, navigationRouter: navRouter) {
            navRouter.navigator?.dismissSelf(animated: true)
        }
        presentNavController(view: view, navRouter: &navRouter)
    }
    
    func handleSelectWorkout(id: String, filename: String) {
        let interactor = DoWorkoutInteractor(workoutId: id, filename: filename)
        let viewModel = DoWorkoutViewModel(interactor: interactor)
        var navRouter = DoWorkoutNavigationRouter(viewModel: viewModel)
        let view = WorkoutPreviewView(viewModel: viewModel, navigationRouter: navRouter)
        presentNavController(view: view, navRouter: &navRouter)
    }
    
    func handleEditWorkout(id: String) {
        return // TODO
    }
    
    func presentNavController<V: View, N: NavigationRouter>(view: V, navRouter: inout N) {
        // Use a navigation controller since we will be pushing views on top of a presented view
        let navController = UINavigationController(rootViewController: UIHostingController(rootView: view))
        navController.setNavigationBarHidden(true, animated: false)
        navRouter.navigator = navController
        navigator?.present(navController, animated: true)
    }
}
