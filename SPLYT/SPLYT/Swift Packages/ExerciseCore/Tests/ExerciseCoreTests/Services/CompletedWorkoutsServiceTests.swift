//
//  CompletedWorkoutsServiceTests.swift
//  
//
//  Created by Ethan Van Heerden on 7/28/23.
//

import XCTest
@testable import ExerciseCore
import Mocking

final class CompletedWorkoutsServiceTests: XCTestCase {
    typealias WorkoutFixtures = WorkoutModelFixtures
    private var cacheInteractor: MockCacheInteractor!
    private var sut: CompletedWorkoutsService!
    private let histories: [WorkoutHistory] = WorkoutFixtures.workoutHistories

    override func setUpWithError() throws {
        self.cacheInteractor = MockCacheInteractor()
        self.sut = CompletedWorkoutsService(cacheInteractor: cacheInteractor)
    }
    
    func testDeleteWorkoutHistory_CacheError() {
        cacheInteractor.loadThrow = true
        XCTAssertThrowsError(try sut.deleteWorkoutHistory(historyId: WorkoutFixtures.legWorkoutHistoryId))
        XCTAssertTrue(cacheInteractor.loadCalled)
        XCTAssertFalse(cacheInteractor.saveCalled)
    }
    
    func testDeleteWorkoutHistory_Success() throws {
        cacheInteractor.stubData = histories
        let result = try sut.deleteWorkoutHistory(historyId: WorkoutFixtures.legWorkoutHistoryId)
        
        let expectedHistories: [WorkoutHistory] = [
            WorkoutFixtures.fullBodyWorkout_WorkoutHistory
        ]
        
        XCTAssertEqual(result, expectedHistories)
        XCTAssertTrue(cacheInteractor.loadCalled)
        XCTAssertTrue(cacheInteractor.saveCalled)
    }
}
