//
//  WorkoutsNavigationRouter.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 12/20/22.
//

import Foundation
import Core
import SwiftUI

// MARK: - Navigation Events

enum WorkoutsNavigationEvent {
    case createPlan
    case createWorkout
}

// MARK: - Router

final class WorkoutsNavigationRouter: NavigationRouter {
    weak var navigator: Navigator?
    
    func navigate(_ event: WorkoutsNavigationEvent) {
        switch event {
        case .createPlan:
            handleCreatePlan()
        case .createWorkout:
            handleCreateWorkout()
        }
    }
}

// MARK: - Private

private extension WorkoutsNavigationRouter {
    func handleCreatePlan() {
        let view = Text("CREATE PLAN")
        navigator?.present(UIHostingController(rootView: view), animated: true)
    }
    
    func handleCreateWorkout() {
        let view = Text("CREATE WORKOUT")
        navigator?.present(UIHostingController(rootView: view), animated: true)
    }
}
