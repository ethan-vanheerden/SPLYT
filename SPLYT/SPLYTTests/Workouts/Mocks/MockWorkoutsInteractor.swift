//
//  MockWorkoutsInteractor.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 12/24/22.
//

import Foundation
@testable import SPLYT

struct MockWorkoutsInteractor: WorkoutsInteractorType {
    
    func interact(with domainAction: WorkoutsDomainAction) async -> WorkoutsDomainResult {
        switch domainAction {
        case .loadWorkouts:
            return .loaded([])
        }
    }
}
