//
//  NameWorkoutNavigationRouter.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 1/9/23.
//

import Foundation
import Core
import SwiftUI
import ExerciseCore
import DesignSystem

// MARK: - Navigation Events

enum NameWorkoutNavigationEvent {
    case next(type: RoutineType, navState: NameWorkoutNavigationState)
}

// MARK: - Navigation State

/// This is used to send needed information from the Name Workout screen to the next screen
struct NameWorkoutNavigationState {
    let name: String
}

// MARK: - Router

final class NameWorkoutNavigationRouter: NavigationRouter {
    weak var navigator: Navigator?
    private let buildWorkoutService: BuildWorkoutServiceType
    private let saveAction: ((Workout) -> Void)? // Custom override save workout action
    
    init(buildWorkoutService: BuildWorkoutServiceType = BuildWorkoutService(),
         saveAction: ((Workout) -> Void)? = nil) {
        self.buildWorkoutService = buildWorkoutService
        self.saveAction = saveAction
    }
    
    func navigate(_ event: NameWorkoutNavigationEvent) {
        switch event {
        case let .next(type, navState):
            handleNext(type: type, navState: navState)
        }
    }
}

// MARK: - Private

private extension NameWorkoutNavigationRouter {
    
    func handleNext(type: RoutineType, navState: NameWorkoutNavigationState) {
        switch type {
        case .workout:
            startBuildWorkout(navState: navState)
        case .plan:
            startBuildPlan(navState: navState)
        }
    }
    
    func startBuildWorkout(navState: NameWorkoutNavigationState) {
        let interactor = BuildWorkoutInteractor(service: buildWorkoutService,
                                                nameState: navState, 
                                                saveAction: saveAction)
        let viewModel = BuildWorkoutViewModel(interactor: interactor)
        let navRouter = BuildWorkoutNavigationRouter(viewModel: viewModel)
        navRouter.navigator = navigator
        let view = BuildWorkoutView(viewModel: viewModel,
                                    navigationRouter: navRouter)

        navigator?.push(view, animated: true)
    }
    
    func startBuildPlan(navState: NameWorkoutNavigationState) {
        let interactor = BuildPlanInteractor(nameState: navState)
        let viewModel = BuildPlanViewModel(interactor: interactor)
        let navRouter = BuildPlanNavigationRouter(viewModel: viewModel)
        navRouter.navigator = navigator
        let view = BuildPlanView(viewModel: viewModel,
                                 navigationRouter: navRouter)
        
        navigator?.push(view, animated: true)
    }
}
