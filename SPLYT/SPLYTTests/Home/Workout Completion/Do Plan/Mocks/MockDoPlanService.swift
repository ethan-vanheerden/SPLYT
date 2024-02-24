//
//  MockDoPlanService.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 7/15/23.
//

import Foundation
@testable import SPLYT
@testable import ExerciseCore
import Mocking

final class MockDoPlanService: DoPlanServiceType {
    typealias WorkoutFixtures = WorkoutModelFixtures
    
    var loadPlanThrow = false
    func loadPlan(planId: String) throws -> Plan {
        if loadPlanThrow { throw MockError.someError }
        return WorkoutFixtures.myPlan
    }
    
    private(set) var deleteWorkoutCalled = false
    var deleteWorkoutThrow = false
    func deleteWorkout(planId: String, workoutId: String) throws {
        deleteWorkoutCalled = true
        if deleteWorkoutThrow { throw MockError.someError }
    }
}
