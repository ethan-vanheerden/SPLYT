//
//  CustomExerciseViewModel.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 5/22/24.
//

import Foundation
import Core
import ExerciseCore

// MARK: - Events

enum CustomExerciseViewEvent {
    case load
    case updateExerciseName(to: String)
    case updateMuscleWorked(muscle: MusclesWorked, isSelected: Bool)
    case submit
    case save
}

// MARK: - View Model

final class CustomExerciseViewModel: ViewModel {
    @Published private(set) var viewState: CustomExerciseViewState = .loading
    private let interactor: CustomExerciseInteractor
    private let reducer = CustomExerciseReducer()
    
    init(interactor: CustomExerciseInteractor) {
        self.interactor = interactor
    }
    
    func send(_ event: CustomExerciseViewEvent) async {
        switch event {
        case .load:
            await react(domainAction: .load)
        case .updateExerciseName(let newName):
            await react(domainAction: .updateExerciseName(to: newName))
        case let .updateMuscleWorked(muscle, isSelected):
            await react(domainAction: .updateMuscleWorked(muscle: muscle, 
                                                          isSelected: isSelected))
        case .submit:
            await react(domainAction: .submit)
        case .save:
            await react(domainAction: .save)
        }
    }
}

// MARK: - Private

private extension CustomExerciseViewModel {
    func updateViewState(_ viewState: CustomExerciseViewState) async {
        await MainActor.run {
            self.viewState = viewState
        }
    }
    
    func react(domainAction: CustomExerciseDomainAction) async {
        let domain = await interactor.interact(with: domainAction)
        let newViewState = reducer.reduce(domain)
        await updateViewState(newViewState)
    }
}
