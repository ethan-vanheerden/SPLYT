//
//  NameWorkoutNavigationRouter.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 1/9/23.
//

import Foundation
import Core
import SwiftUI

// MARK: - Navigation Events

enum NameWorkoutNavigationEvent {
    case next(type: NameWorkoutBuildType, navState: NameWorkoutNavigationState)
}

// MARK: - Navigation State

/// This is used to send needed information from the Name Workout screen to the next screen
struct NameWorkoutNavigationState {
    let workoutName: String
}

// MARK: - Router

final class NameWorkoutNavigationRouter: NavigationRouter {
    weak var navigator: Navigator?
    
    func navigate(_ event: NameWorkoutNavigationEvent) {
        switch event {
        case let .next(type, navState):
            handleNext(type: type, navState: navState)
        }
    }
}

// MARK: - Private

private extension NameWorkoutNavigationRouter {
    
    func handleNext(type: NameWorkoutBuildType, navState: NameWorkoutNavigationState) {
        switch type {
        case .workout:
            startBuildWorkout(navState: navState)
        case .plan:
            startBuildPlan(navState: navState)
        }
    }
    
    func startBuildWorkout(navState: NameWorkoutNavigationState) {
        let interactor = BuildWorkoutInteractor(nameState: navState)
        let viewModel = BuildWorkoutViewModel(interactor: interactor)
        let navRouter = BuildWorkoutNavigationRouter()
        navRouter.navigator = navigator
        let view = BuildWorkoutView(viewModel: viewModel,
                                    navigationRouter: navRouter,
                                    transformer: BuildWorkoutTransformer())
        let vc = UIHostingController(rootView: view)
        
        navigator?.push(vc, animated: true)
    }
    
    func startBuildPlan(navState: NameWorkoutNavigationState) {
        
    }
}
