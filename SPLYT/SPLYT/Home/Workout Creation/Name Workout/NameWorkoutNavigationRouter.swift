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
    case next(NameWorkoutNavigationState)
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
        case .next(let state):
            handleNext(state: state)
        }
    }
}

// MARK: - Private

private extension NameWorkoutNavigationRouter {
    func handleNext(state: NameWorkoutNavigationState) {
        let interactor = BuildWorkoutInteractor(nameState: state)
        let viewModel = BuildWorkoutViewModel(interactor: interactor)
        let navRouter = BuildWorkoutNavigationRouter()
        navRouter.navigator = navigator
        let view = BuildWorkoutView(viewModel: viewModel,
                                    navigationRouter: navRouter,
                                    transformer: BuildWorkoutTransformer())
        let vc = UIHostingController(rootView: view)
        
        navigator?.push(vc, animated: true)
    }
}
