//
//  MockWorkoutsInteractor.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 12/24/22.
//

import Foundation
@testable import SPLYT

struct MockWorkoutsInteractor: HomeInteractorType {
    
    func interact(with domainAction: HomeDomainAction) async -> HomeDomainResult {
        switch domainAction {
        case .loadWorkouts:
            return .loaded([])
        }
    }
}
