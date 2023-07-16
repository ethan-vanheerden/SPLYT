//
//  BuildPlanServiceTests.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 7/15/23.
//

import XCTest
@testable import SPLYT
import Mocking
@testable import ExerciseCore

final class BuildPlanServiceTests: XCTestCase {
    typealias WorkoutFixtures = WorkoutModelFixtures
    private var routineCacheInteractor: MockCacheInteractor!
    private var sut: BuildPlanService!
    
    override func setUpWithError() throws {
        routineCacheInteractor = MockCacheInteractor()
        let routineService = CreatedRoutinesService(cacheInteractor: routineCacheInteractor)
        sut = BuildPlanService(routineService: routineService)
    }
    
    func testSavePlan_RoutineServiceError() {
        routineCacheInteractor.saveThrow = true
        XCTAssertThrowsError(try sut.savePlan(WorkoutFixtures.myPlan))
        XCTAssertTrue(routineCacheInteractor.saveCalled)
    }
    
    func testSavePlan_Success() throws {
        try sut.savePlan(WorkoutFixtures.myPlan)
        
        let data = routineCacheInteractor.stubData as? CreatedRoutines
        let expectedPlans: [String: Plan] = [
            WorkoutFixtures.myPlanId: WorkoutFixtures.myPlan
        ]
        
        XCTAssertEqual(data?.plans, expectedPlans)
        XCTAssertTrue(routineCacheInteractor.saveCalled)
    }
}
