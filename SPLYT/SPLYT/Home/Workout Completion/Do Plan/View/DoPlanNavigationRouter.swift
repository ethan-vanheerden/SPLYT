//
//  DoPlanNavigationRouter.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 7/4/23.
//

import Foundation
import Core
import SwiftUI
import DesignSystem

// MARK: - Navigation Events

enum DoPlanNavigationEvent {
    case exit
    case doWorkout(workoutId: String)
}

// MARK: - Router

final class DoPlanNavigationRouter: NavigationRouter {
    private let planId: String
    weak var navigator: Navigator?
    
    init(planId: String) {
        self.planId = planId
    }
    
    func navigate(_ event: DoPlanNavigationEvent) {
        switch event {
        case .exit:
            handleExit()
        case let .doWorkout(workoutId):
            handleDoWorkout(workoutId: workoutId)
        }
    }
}

// MARK: - Private

private extension DoPlanNavigationRouter {
    func handleExit() {
        navigator?.dismiss(animated: true)
    }
    
    func handleDoWorkout(workoutId: String) {
        let interactor = DoWorkoutInteractor(workoutId: workoutId,
                                             planId: planId)
        let viewModel = DoWorkoutViewModel(interactor: interactor)
        let navRouter = DoWorkoutNavigationRouter(viewModel: viewModel) { [weak self] in
            self?.navigator?.pop(animated: true) // Goes back to the workouts in the plan
        } exitAction: { _ in }
        let view = WorkoutPreviewView(viewModel: viewModel, navigationRouter: navRouter)
        
        navRouter.navigator = navigator
        let vc = UIHostingController(rootView: view.environmentObject(UserTheme.shared))
        navigator?.push(vc, animated: true)
    }
}
