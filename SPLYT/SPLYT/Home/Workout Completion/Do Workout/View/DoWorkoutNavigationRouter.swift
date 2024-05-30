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
}

// MARK: - Router

final class DoWorkoutNavigationRouter: NavigationRouter {
    weak var navigator: Navigator?
    // Has reference since multiple screens will have this same view model
    private let viewModel: DoWorkoutViewModel
    private let backAction: () -> Void
    private let exitAction: (String) -> Void // To open the workout details page after finishing a workout
    
    init(viewModel: DoWorkoutViewModel,
         backAction: @escaping () -> Void,
         exitAction: @escaping (String) -> Void) {
        self.viewModel = viewModel
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
        let vc = UIHostingController(rootView: view.environmentObject(UserTheme.shared))
        self.navigator?.push(vc, animated: false)
    }
}
