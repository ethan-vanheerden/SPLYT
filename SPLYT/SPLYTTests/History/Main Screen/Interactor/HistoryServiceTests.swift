//
//  HistoryServiceTests.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 7/21/23.
//

import XCTest
@testable import SPLYT
import Mocking
@testable import ExerciseCore

final class HistoryServiceTests: XCTestCase {
    typealias WorkoutFixtures = WorkoutModelFixtures
    private var completedWorkoutsService: MockCompletedWorkoutsService!
    private var cacheInteractor: MockCacheInteractor!
    private var sut: HistoryService!
    
    override func setUpWithError() throws {
        self.completedWorkoutsService = MockCompletedWorkoutsService()
        self.cacheInteractor = MockCacheInteractor()
        self.sut = HistoryService(completedWorkoutsService: completedWorkoutsService,
                                  cacheInteractor: cacheInteractor)
    }
    
    func testLoadWorkoutHistory_CacheError() {
        cacheInteractor.fileExistsThrow = true
        XCTAssertThrowsError(try sut.loadWorkoutHistory())
        XCTAssertFalse(cacheInteractor.saveCalled)
        XCTAssertFalse(cacheInteractor.loadCalled)
    }
    
    func testLoadWorkoutHistory_FileNoExist_LoadsEmptyHistory() throws {
        let result = try sut.loadWorkoutHistory()
        
        XCTAssertEqual(result, [])
        XCTAssertTrue(cacheInteractor.saveCalled)
        XCTAssertTrue(cacheInteractor.loadCalled)
    }
    
    func testLoadWorkoutHistory_FileExists_Success() throws {
        cacheInteractor.stubFileExists = true
        cacheInteractor.stubData = WorkoutFixtures.workoutHistories
        
        let result = try sut.loadWorkoutHistory()
        
        XCTAssertEqual(result, WorkoutFixtures.workoutHistories)
        XCTAssertFalse(cacheInteractor.saveCalled)
        XCTAssertTrue(cacheInteractor.loadCalled)
    }
    
    func testDeleteWorkoutHistory_ServiceError() {
        completedWorkoutsService.deleteHistoryThrow = true
        XCTAssertThrowsError(try sut.deleteWorkoutHistory(historyId: WorkoutFixtures.legWorkoutHistoryId))
        XCTAssertTrue(completedWorkoutsService.deleteHistoryCalled)
    }
    
    func testDeleteWorkoutHistory_Success() throws {
        let result = try sut.deleteWorkoutHistory(historyId: WorkoutFixtures.legWorkoutHistoryId)
        
        XCTAssertEqual(result, [WorkoutFixtures.fullBodyWorkout_WorkoutHistory])
        XCTAssertTrue(completedWorkoutsService.deleteHistoryCalled)
    }
}
