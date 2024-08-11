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
    case showMeExercise(exerciseName: String)
}

// MARK: - Router

final class CustomExerciseNavigationRouter: NavigationRouter {
    weak var navigator: Navigator?
    private let saveAction: (String) -> Void
    private let exerciseAlreadyExistsAction: (String) -> Void
    
    init(saveAction: @escaping (String) -> Void,
         exerciseAlreadyExistsAction: @escaping (String) -> Void) {
        self.saveAction = saveAction
        self.exerciseAlreadyExistsAction = exerciseAlreadyExistsAction
    }
    
    func navigate(_ event: CustomExerciseNavigationEvent) {
        switch event {
        case .exit:
            handleExit()
        case .save(let exerciseName):
            handleSave(exerciseName: exerciseName)
        case .showMeExercise(let exerciseName):
            handleShowMeExercise(exerciseName: exerciseName)
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
    
    func handleShowMeExercise(exerciseName: String) {
        let exerciseAlreadyExistsAction = exerciseAlreadyExistsAction
        navigator?.dismissWithCompletion(animated: true,
                                         completion: { exerciseAlreadyExistsAction(exerciseName) })
    }
}
