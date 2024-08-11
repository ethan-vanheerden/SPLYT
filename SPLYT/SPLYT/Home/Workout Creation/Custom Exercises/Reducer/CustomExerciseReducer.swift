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
        case let .dialog(dialog, domain):
            let display = getDisplay(domain: domain, dialog: dialog)
            return .loaded(display)
        }
    }
}

// MARK: - Private

private extension CustomExerciseReducer {
    func getDisplay(domain: CustomExerciseDomain, dialog: CustomExerciseDialog? = nil) -> CustomExerciseDisplay {
        return .init(exerciseName: domain.exerciseName,
                     musclesWorked: domain.musclesWorked,
                     exerciseNameEntry: exerciseNameEntry,
                     musclesWorkedHeader: musclesWorkedHeader,
                     canSave: domain.canSave,
                     isSaving: domain.isSaving,
                     shownDialog: dialog,
                     exerciseExistsDialog: exerciseExistsDialog)
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
    
    var exerciseExistsDialog: DialogViewState {
        return .init(title: Strings.exerciseExists,
                     subtitle: Strings.exerciseExistsDescription,
                     primaryButtonTitle: Strings.showMe,
                     secondaryButtonTitle: Strings.cancel)
    }
}

// MARK: - Strings

fileprivate struct Strings {
    static let exerciseName = "Exercise Name"
    static let myAwesomeExercise = "My Awesome Exercise"
    static let musclesWorked = "Muscles Worked"
    static let exerciseExists = "Exercise Aready Exists"
    static let exerciseExistsDescription = """
We already have this exercise. Would you like to see it?
"""
    static let showMe = "Show Me"
    static let cancel = "Cancel"
}
