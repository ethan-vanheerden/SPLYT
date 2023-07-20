//
//  WorkoutDetailsReducer.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 7/20/23.
//

import Foundation
import DesignSystem

struct WorkoutDetailsReducer {
    func reduce(_ domain: WorkoutDetailsDomainResult) -> WorkoutDetailsViewState {
        return .error
    }
}

// MARK: - Private

private extension WorkoutDetailsReducer {
    func getDisplay(domain: WorkoutDetailsDomain) -> WorkoutDetailsDisplay {
        return .init()
    }
}
