//
//  DoWorkoutNavigationRouter.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 5/17/23.
//

import Foundation
import Core
import SwiftUI

// MARK: - Navigation Events

enum DoWorkoutNavigationEvent {
    case back
    case exit
    case beginWorkout
}

// MARK: - Router

final class DoWorkoutNavigationRouter: NavigationRouter {
    weak var navigator: Navigator?
    // Has reference since multiple screens will have this same view model
    private let viewModel: DoWorkoutViewModel
    private let backAction: () -> Void
    
    init(viewModel: DoWorkoutViewModel,
         backAction: @escaping () -> Void) {
        self.viewModel = viewModel
        self.backAction = backAction
    }
    
    func navigate(_ event: DoWorkoutNavigationEvent) {
        switch event {
        case .back:
            handleBack()
        case .exit:
            handleExit()
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
    
    func handleExit() {
        navigator?.dismiss(animated: true)
    }
    
    func handleBeginWorkout() {
        let view = DoWorkoutView(viewModel: viewModel, navigationRouter: self)
        let vc = UIHostingController(rootView: view)
        self.navigator?.push(vc, animated: false)
    }
}
