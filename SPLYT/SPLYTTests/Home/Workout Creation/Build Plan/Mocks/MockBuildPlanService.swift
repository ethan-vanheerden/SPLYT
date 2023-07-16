//
//  MockBuildPlanService.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 7/15/23.
//

import Foundation
@testable import SPLYT
import Mocking
import ExerciseCore

final class MockBuildPlanService: BuildPlanServiceType {
    
    var savePlanThrow = false
    private(set) var savePlanCalled = false
    func savePlan(_: Plan) throws {
        savePlanCalled = true
        if savePlanThrow { throw MockError.someError }
    }
}
