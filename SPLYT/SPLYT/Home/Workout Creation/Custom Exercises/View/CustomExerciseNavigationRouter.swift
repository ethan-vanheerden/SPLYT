//
//  CustomExerciseNavigationRouter.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 5/22/24.
//

import Foundation
import Core

// MARK: - Navigation Events

enum CustomExerciseNavigationEvent {
    case exit
    case save(exerciseName: String)
}

// MARK: - Router

final class CustomExerciseNavigationRouter: NavigationRouter {
    weak var navigator: Navigator?
    private let saveAction: (String) -> Void
    
    init(saveAction: @escaping (String) -> Void) {
        self.saveAction = saveAction
    }
    
    func navigate(_ event: CustomExerciseNavigationEvent) {
        switch event {
        case .exit:
            handleExit()
        case .save(let exerciseName):
            handleSave(exerciseName: exerciseName)
        }
    }
}

// MARK: - Private

private extension CustomExerciseNavigationRouter {
    func handleExit() {
        navigator?.dismiss(animated: true)
    }
    
    func handleSave(exerciseName: String) {
        let saveAction = saveAction
        navigator?.dismissWithCompletion(animated: true,
                                         completion: { saveAction(exerciseName) })
    }
}
