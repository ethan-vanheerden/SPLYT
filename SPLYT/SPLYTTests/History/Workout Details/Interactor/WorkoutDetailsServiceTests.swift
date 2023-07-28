//
//  WorkoutDetailsServiceTests.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 7/28/23.
//

import XCTest
@testable import SPLYT
import Mocking
@testable import ExerciseCore

final class WorkoutDetailsServiceTests: XCTestCase {
    typealias WorkoutFixtures = WorkoutModelFixtures
    private var completedWorkoutsService: MockCompletedWorkoutsService!
    private var cacheInteractor: MockCacheInteractor!
    private var sut: WorkoutDetailsService!

    override func setUpWithError() throws {
        self.completedWorkoutsService = MockCompletedWorkoutsService()
        self.cacheInteractor = MockCacheInteractor()
        self.sut = WorkoutDetailsService(completedWorkoutsService: completedWorkoutsService,
        
                                         cacheInteractor: cacheInteractor)
    }
    
    func testLoadWorkout_CacheError() {
        cacheInteractor.fileExistsThrow = true
        XCTAssertThrowsError(try sut.loadWorkout(historyId: WorkoutFixtures.legWorkoutHistoryId))
        XCTAssertTrue(cacheInteractor.loadCalled)
    }
    
    func testLoadWorkout_WorkoutNotFound_Error() {
        cacheInteractor.stubFileExists = true
        cacheInteractor.stubData = WorkoutFixtures.workoutHistories
        
        XCTAssertThrowsError(try sut.loadWorkout(historyId: "no-exist"))
        XCTAssertTrue(cacheInteractor.loadCalled)
    }
    
    func testLoadWorkout_Success() throws {
        cacheInteractor.stubFileExists = true
        cacheInteractor.stubData = WorkoutFixtures.workoutHistories
        
        let result = try sut.loadWorkout(historyId: WorkoutFixtures.legWorkoutHistoryId)
        
        XCTAssertEqual(result, WorkoutFixtures.legWorkout)
    }
    
    func testDeleteWorkoutHistory_ServiceError() {
        completedWorkoutsService.deleteHistoryThrow = true
        XCTAssertThrowsError(try sut.deleteWorkoutHistory(historyId: WorkoutFixtures.legWorkoutHistoryId))
        XCTAssertTrue(completedWorkoutsService.deleteHistoryCalled)
    }
    
    func testDeleteWorkoutHistory_Success() throws {
        try sut.deleteWorkoutHistory(historyId: WorkoutFixtures.legWorkoutHistoryId)
        XCTAssertTrue(completedWorkoutsService.deleteHistoryCalled)
    }
}
