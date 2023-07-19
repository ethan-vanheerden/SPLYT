//
//  HistoryReducer.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 7/16/23.
//

import Foundation
import DesignSystem
import ExerciseCore

struct HistoryReducer {
    func reduce(_ domain: HistoryDomainResult) -> HistoryViewState {
        switch domain {
        case .error:
            return .error
        case .loaded(let domain):
            let display = getDisplay(domain: domain)
            return .loaded(display)
        case let .dialog(dialog, domain):
            let display = getDisplay(domain: domain, dialog: dialog)
            return .loaded(display)
        }
    }
}

// MARK: - Private

private extension HistoryReducer {
    func getDisplay(domain: HistoryDomain, dialog: HistoryDialog? = nil) -> HistoryDisplay {
        let workouts = WorkoutReducer.createWorkoutRoutineTiles(workouts: domain.workouts,
                                                                isHistory: true)
        
        let display = HistoryDisplay(workouts: workouts,
                                     presentedDialog: dialog,
                                     deleteWorkoutHistoryDialog: deleteWorkoutHistoryDialog)
        
        return display
    }
    
    var deleteWorkoutHistoryDialog: DialogViewState {
        return .init(title: Strings.deleteWorkoutHistory,
                     subtitle: Strings.deleteThisVersion,
                     primaryButtonTitle: Strings.delete,
                     secondaryButtonTitle: Strings.cancel)
    }
}

// MARK: - Strings

fileprivate struct Strings {
    static let deleteWorkoutHistory = "Delete workout history?"
    static let deleteThisVersion = "This will delete only this completed version of the workout. This action can't be undone"
    static let delete = "Delete"
    static let cancel = "Cancel"
}
