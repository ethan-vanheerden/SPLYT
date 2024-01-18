//
//  BuildWorkoutNavigationRouter.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 3/4/23.
//

import Foundation
import Core
import SwiftUI

// MARK: - Navigation Events

enum BuildWorkoutNavigationEvent {
    case exit
    case editSetsReps
    case goBack
}

// MARK: - Router

final class BuildWorkoutNavigationRouter: NavigationRouter {
    weak var navigator: Navigator?
    private let viewModel: BuildWorkoutViewModel
    
    init(viewModel: BuildWorkoutViewModel) {
        self.viewModel = viewModel
    }
    
    func navigate(_ event: BuildWorkoutNavigationEvent) {
        switch event {
        case .exit:
            handleExit()
        case .editSetsReps:
            handleEditSetsReps()
        case .goBack:
            handleGoBack()
        }
    }
}

// MARK: - Private

private extension BuildWorkoutNavigationRouter {
    func handleExit() -> Void {
        navigator?.dismissSelf(animated: true)
    }
    
    func handleEditSetsReps() {
        let view = EditSetsRepsView(viewModel: viewModel,
                                    navigationRouter: self)
        let vc = UIHostingController(rootView: view)
        self.navigator?.push(vc, animated: true)
    }
    
    func handleGoBack() {
        navigator?.pop(animated: true)
    }
}
