//
//  BuildWorkoutNavigationRouter.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 3/4/23.
//

import Foundation
import Core
import SwiftUI
import DesignSystem

// MARK: - Navigation Events

enum BuildWorkoutNavigationEvent {
    case exit
    case editSetsReps
    case goBack
    // The save action uses the exercise name so that the search bar in the build
    // workout page can be updated with it once the custom exercise is created
    case createCustomExercise(exerciseName: String,
                              service: CustomExerciseServiceType? = nil,
                              saveAction: (String) -> Void)
    case dismissReplace
    case replace(exerciseId: String)
}

// MARK: - Router

final class BuildWorkoutNavigationRouter: NavigationRouter {
    weak var navigator: Navigator?
    private let viewModel: BuildWorkoutViewModel
    private let replaceExerciseAction: ((String) -> Void)?
    
    init(viewModel: BuildWorkoutViewModel,
         replaceExerciseAction: ((String) -> Void)? = nil) {
        self.viewModel = viewModel
        self.replaceExerciseAction = replaceExerciseAction
    }
    
    func navigate(_ event: BuildWorkoutNavigationEvent) {
        switch event {
        case .exit:
            handleExit()
        case .editSetsReps:
            handleEditSetsReps()
        case .goBack:
            handleGoBack()
        case let .createCustomExercise(exerciseName, service, saveAction):
            handleCreateCustomExercise(exerciseName: exerciseName,
                                       service: service,
                                       saveAction: saveAction)
        case .dismissReplace:
            handleDismissReplace()
        case .replace(let exerciseId):
            handleReplace(exerciseId: exerciseId)
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
        let vc = UIHostingController(rootView: view.withUserTheme())
        self.navigator?.push(vc, animated: true)
    }
    
    func handleGoBack() {
        navigator?.pop(animated: true)
    }
    
    func handleCreateCustomExercise(exerciseName: String, 
                                    service: CustomExerciseServiceType?,
                                    saveAction: @escaping (String) -> Void) {
        let interactor = CustomExerciseInteractor(exerciseName: exerciseName,
                                                  service: service ?? CustomExerciseService())
        let viewModel = CustomExerciseViewModel(interactor: interactor)
        let navRouter = CustomExerciseNavigationRouter(saveAction: saveAction)
        let view = CustomExerciseView(viewModel: viewModel, navigationRouter: navRouter)
        navRouter.navigator = navigator
        
        let vc = UIHostingController(rootView: view.withUserTheme())
        navigator?.present(vc, animated: true)
    }
    
    func handleDismissReplace() {
        navigator?.dismiss(animated: true)
    }
    
    func handleReplace(exerciseId: String) {
        let replaceExerciseAction = replaceExerciseAction
        navigator?.dismissWithCompletion(animated: true,
                                         completion: {
            replaceExerciseAction?(exerciseId)
        })
    }
}
