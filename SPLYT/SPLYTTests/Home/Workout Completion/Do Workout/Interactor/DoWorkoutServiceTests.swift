//
//  DoWorkoutServiceTests.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 6/11/23.
//

import XCTest
@testable import SPLYT
@testable import ExerciseCore
import Mocking

final class DoWorkoutServiceTests: XCTestCase {
    typealias WorkoutFixtures = WorkoutModelFixtures
    private var cacheInteractor = MockCacheInteractor.self
    private var workoutCacheInteractor = MockCacheInteractor.self
    private var sut: DoWorkoutService!
    
    override func setUpWithError() throws {
        cacheInteractor.reset()
        workoutCacheInteractor.reset()
        let workoutService = CreatedWorkoutsService(cacheInteractor: workoutCacheInteractor)
        self.sut = DoWorkoutService(cacheInteractor: cacheInteractor,
                                    workoutService: workoutService)
    }
    
    func testLoadWorkout_FileNoExist_ErrorLoading() {
        workoutCacheInteractor.fileExistsThrow = true
        XCTAssertThrowsError(try sut.loadWorkout(filename: WorkoutFixtures.legWorkoutFilename, workoutId: WorkoutFixtures.legWorkoutId))
    }
    
    func testLoadWorkout_FileNoExist_LoadsFromCreatedWorkouts() throws {
        workoutCacheInteractor.stubFileExists = true
        workoutCacheInteractor.stubData = WorkoutFixtures.loadedCreatedWorkouts
        
        let result = try sut.loadWorkout(filename: WorkoutFixtures.legWorkoutFilename,
                                         workoutId: WorkoutFixtures.legWorkoutId)
        
        XCTAssertEqual(result, WorkoutFixtures.legWorkout)
    }
    
}
