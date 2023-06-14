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
    case exit
    case beginWorkout
}

// MARK: - Router

final class DoWorkoutNavigationRouter: NavigationRouter {
    weak var navigator: Navigator?
    // Has reference since multiple screens will have this same view model
    private let viewModel: DoWorkoutViewModel
    
    init(viewModel: DoWorkoutViewModel) {
        self.viewModel = viewModel
    }
    
    func navigate(_ event: DoWorkoutNavigationEvent) {
        switch event {
        case .exit:
            handleExit()
        case .beginWorkout:
            handleBeginWorkout()
        }
    }
}

// MARK: - Private

private extension DoWorkoutNavigationRouter {
    func handleExit() {
        self.navigator?.dismissSelf(animated: true)
    }
    
    func handleBeginWorkout() {
        let view = DoWorkoutView(viewModel: viewModel, navigationRouter: self)
        let vc = UIHostingController(rootView: view)
        self.navigator?.push(vc, animated: false)
    }
}
