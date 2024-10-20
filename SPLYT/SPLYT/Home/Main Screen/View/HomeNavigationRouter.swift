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
import DesignSystem

// MARK: - Navigation Events

enum HomeNavigationEvent {
    case createPlan
    case createWorkout
    case seletectWorkout(id: String)
    case editWorkout(id: String)
    case selectPlan(id: String)
    case editPlan(id: String)
    case resumeWorkout
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
        case .resumeWorkout:
            handleResumeWorkout()
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
        }.withUserTheme()
        presentNavController(view: view, navRouter: &navRouter)
    }
    
    func handleSelectWorkout(id: String) {
        let interactor = DoWorkoutInteractor(workoutId: id)
        let viewModel = DoWorkoutViewModel(interactor: interactor)
        var navRouter = DoWorkoutNavigationRouter(viewModel: viewModel) { [weak self] in
            self?.navigator?.dismiss(animated: true)
        } exitAction: { [weak self] workoutDetailsId in
            self?.openWorkoutDetails(workoutDetailsId: workoutDetailsId)
        }
        let view = WorkoutPreviewView(viewModel: viewModel, 
                                      navigationRouter: navRouter).withUserTheme()
        presentNavController(view: view, navRouter: &navRouter)
    }
    
    func handleEditWorkout(id: String) {
        return // TODO
    }
    
    func handleSelectPlan(id: String) {
        let interactor = DoPlanInteractor(planId: id)
        let viewModel = DoPlanViewModel(interactor: interactor)
        var navRouter = DoPlanNavigationRouter(planId: id) { [weak self] workoutDetailsId in
            self?.openWorkoutDetails(workoutDetailsId: workoutDetailsId)
        }
        let view = DoPlanView(viewModel: viewModel, 
                              navigationRouter: navRouter).withUserTheme()
        presentNavController(view: view, navRouter: &navRouter)
    }
    
    func handleEditPlan(id: String) {
        // TODO
    }
    
    func openWorkoutDetails(workoutDetailsId: String) {
        let interactor = WorkoutDetailsInteractor(historyId: workoutDetailsId)
        let viewModel = WorkoutDetailsViewModel(interactor: interactor)
        let navRouter = WorkoutDetailsNavigationRouter()
        let view = WorkoutDetailsView(viewModel: viewModel, navigationRouter: navRouter)
        navRouter.navigator = navigator
        
        navigator?.present(view, animated: true)
    }
    
    func handleResumeWorkout() {
        let interactor = DoWorkoutInteractor()
        let viewModel = DoWorkoutViewModel(interactor: interactor)
        var navRouter = DoWorkoutNavigationRouter(viewModel: viewModel) { [weak self] in
            self?.navigator?.dismiss(animated: true)
        } exitAction: {
            [weak self] workoutDetailsId in
            self?.openWorkoutDetails(workoutDetailsId: workoutDetailsId)
        }
        let view = DoWorkoutView(viewModel: viewModel,
                                 navigationRouter: navRouter,
                                 fromCache: true).withUserTheme()
        presentNavController(view: view, navRouter: &navRouter)
    }
}
