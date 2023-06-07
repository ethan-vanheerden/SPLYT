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
    case seletectWorkout(id: String)
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
        case .seletectWorkout(let id):
            handleSelectWorkout(id: id)
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
    
    func handleSelectWorkout(id: String) {
        // TODO: 44 - remove with cache refactor
        let cache = WorkoutHistoryCacheRequest(filename: id)
        let service = DoWorkoutService(workoutCacheInteractor: cache)
        let interactor = DoWorkoutInteractor(workoutId: id, service: service)
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
