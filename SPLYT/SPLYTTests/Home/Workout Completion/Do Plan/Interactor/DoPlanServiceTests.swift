//
//  DoPlanServiceTests.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 7/15/23.
//

import XCTest
@testable import SPLYT
import Mocking
@testable import ExerciseCore

final class DoPlanServiceTests: XCTestCase {
    typealias WorkoutFixtures = WorkoutModelFixtures
    private var routineCacheInteractor: MockCacheInteractor!
    private var sut: DoPlanService!

    override func setUpWithError() throws {
        routineCacheInteractor = MockCacheInteractor()
        let routineService = CreatedRoutinesService(cacheInteractor: routineCacheInteractor)
        sut = DoPlanService(routineService: routineService)
    }
    
    func testLoadPlan_RoutineServiceError() {
        routineCacheInteractor.loadThrow = true
        routineCacheInteractor.stubFileExists = true
        routineCacheInteractor.stubData = WorkoutFixtures.loadedRoutines
        
        XCTAssertThrowsError(try sut.loadPlan(planId: WorkoutFixtures.myPlanId))
    }
    
    func testLoadPlan_PlanNoExist_Error() {
        routineCacheInteractor.stubFileExists = true
        routineCacheInteractor.stubData = WorkoutFixtures.loadedRoutines
        
        XCTAssertThrowsError(try sut.loadPlan(planId: "not-a-plan"))
    }
    
    func testLoadPlan_Success() throws {
        routineCacheInteractor.stubFileExists = true
        routineCacheInteractor.stubData = WorkoutFixtures.loadedRoutines
        
        let result = try sut.loadPlan(planId: WorkoutFixtures.myPlanId)
        
        XCTAssertEqual(result, WorkoutFixtures.myPlan)
    }
}
