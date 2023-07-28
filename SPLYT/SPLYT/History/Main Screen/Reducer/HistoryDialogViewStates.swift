//
//  HistoryDialogViewState.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 7/20/23.
//

import Foundation
import DesignSystem

/// Contains common `DialogViewState`s used in history-related views.
struct HistoryDialogViewStates {
    static let deleteWorkoutHistory = DialogViewState(title: Strings.deleteWorkoutHistory,
                                                      subtitle: Strings.deleteThisVersion,
                                                      primaryButtonTitle: Strings.delete,
                                                      secondaryButtonTitle: Strings.cancel)
}

fileprivate struct Strings {
    static let deleteWorkoutHistory = "Delete workout history?"
    static let deleteThisVersion = "This will delete only this completed version of the workout. This action can't be undone."
    static let delete = "Delete"
    static let cancel = "Cancel"
}
