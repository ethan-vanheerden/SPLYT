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
        // TODO: entry point for next screen
        let vc = UIHostingController(rootView: Text(state.workoutName))
        
        navigator?.push(vc, animated: true)
    }
}
