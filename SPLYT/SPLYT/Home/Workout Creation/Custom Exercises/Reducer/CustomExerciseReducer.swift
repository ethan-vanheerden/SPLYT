//
//  CustomExerciseReducer.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 5/22/24.
//

import Foundation
import DesignSystem

struct CustomExerciseReducer {
    func reduce(_ domainResult: CustomExerciseDomainResult) -> CustomExerciseViewState {
        switch domainResult {
        case .error:
            return .error
        case .loaded(let domain):
            let display = getDisplay(domain: domain)
            return .loaded(display)
        case .exit(let domain):
            let display = getDisplay(domain: domain)
            return .exit(display)
        }
    }
}

// MARK: - Private

private extension CustomExerciseReducer {
    func getDisplay(domain: CustomExerciseDomain) -> CustomExerciseDisplay {
        return .init(exerciseName: domain.exerciseName,
                     musclesWorked: domain.musclesWorked,
                     exerciseNameEntry: exerciseNameEntry,
                     musclesWorkedHeader: musclesWorkedHeader,
                     canSave: domain.canSave,
                     isSaving: domain.isSaving)
    }
    
    var exerciseNameEntry: TextEntryViewState {
        return .init(title: Strings.exerciseName,
                     placeholder: Strings.myAwesomeExercise,
                     capitalization: .everyWord,
                     autoFocus: true)
    }
    
    var musclesWorkedHeader: SectionHeaderViewState {
        return .init(title: Strings.musclesWorked,
                     includeLine: false)
    }
}

// MARK: - Strings

fileprivate struct Strings {
    static let exerciseName = "Exercise Name"
    static let myAwesomeExercise = "My Awesome Exercise"
    static let musclesWorked = "Muscles Worked"
}
