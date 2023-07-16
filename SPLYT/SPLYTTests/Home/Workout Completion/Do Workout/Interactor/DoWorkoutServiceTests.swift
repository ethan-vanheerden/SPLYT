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
    private var cacheInteractor: MockCacheInteractor!
    private var routineCacheInteractor: MockCacheInteractor!
    private var sut: DoWorkoutService!
    
    override func setUpWithError() throws {
        cacheInteractor = MockCacheInteractor()
        routineCacheInteractor = MockCacheInteractor()
        let routineService = CreatedRoutinesService(cacheInteractor: routineCacheInteractor)
        self.sut = DoWorkoutService(cacheInteractor: cacheInteractor,
                                    routineService: routineService)
    }
    
    func testLoadWorkout_FileNoExist_ErrorLoading() {
        routineCacheInteractor.fileExistsThrow = true
        XCTAssertThrowsError(try sut.loadWorkout(workoutId: WorkoutFixtures.legWorkoutId,
                                                 historyFilename: WorkoutFixtures.legWorkoutFilename))
    }
    
    func testLoadWorkout_FileNoExist_LoadsFromCreatedWorkouts() throws {
        routineCacheInteractor.stubFileExists = true
        routineCacheInteractor.stubData = WorkoutFixtures.loadedRoutines
        
        let result = try sut.loadWorkout(workoutId: WorkoutFixtures.legWorkoutId,
                                         historyFilename: WorkoutFixtures.legWorkoutFilename)
        
        XCTAssertEqual(result, WorkoutFixtures.legWorkout)
    }
    
    func testLoadWorkout_FileExists_ErrorLoading() {
        cacheInteractor.stubFileExists = true
        cacheInteractor.loadThrow = true
        XCTAssertThrowsError(try sut.loadWorkout(workoutId: WorkoutFixtures.legWorkoutId,
                                                 historyFilename: WorkoutFixtures.legWorkoutFilename))
    }
    
    func testLoadWorkout_FileExists_NoWorkoutsFound() {
        cacheInteractor.stubFileExists = true
        cacheInteractor.stubData = [Workout]()
        XCTAssertThrowsError(try sut.loadWorkout(workoutId: WorkoutFixtures.legWorkoutId,
                                                 historyFilename: WorkoutFixtures.legWorkoutFilename))
    }
    
    func testLoadWorkout_FileExists_Success() throws {
        cacheInteractor.stubFileExists = true
        cacheInteractor.stubData = [WorkoutFixtures.legWorkout]
        
        let result = try sut.loadWorkout(workoutId: WorkoutFixtures.legWorkoutId,
                                         historyFilename: WorkoutFixtures.legWorkoutFilename)
        
        XCTAssertEqual(result, WorkoutFixtures.legWorkout)
    }
    
    func testSaveWorkout_FileNoExist_ErrorSaving() {
        cacheInteractor.saveThrow = true
        XCTAssertThrowsError(try sut.saveWorkout(workout: WorkoutFixtures.legWorkout,
                                                 historyFilename: WorkoutFixtures.legWorkoutFilename))
        XCTAssertTrue(cacheInteractor.saveCalled)
        XCTAssertFalse(routineCacheInteractor.saveCalled)
    }
    
    func testSaveWorkout_FileExist_ErrorLoading() {
        cacheInteractor.stubFileExists = true
        cacheInteractor.loadThrow = true
        XCTAssertThrowsError(try sut.saveWorkout(workout: WorkoutFixtures.legWorkout,
                                                 historyFilename: WorkoutFixtures.legWorkoutFilename))
        XCTAssertFalse(cacheInteractor.saveCalled)
        XCTAssertFalse(routineCacheInteractor.saveCalled)
    }
    
    func testSaveWorkout_FileExist_ErrorSaving() {
        cacheInteractor.stubFileExists = true
        cacheInteractor.stubData = [WorkoutFixtures.legWorkout]
        cacheInteractor.saveThrow = true
        XCTAssertThrowsError(try sut.saveWorkout(workout: WorkoutFixtures.legWorkout,
                                                 historyFilename: WorkoutFixtures.legWorkoutFilename))
        XCTAssertTrue(cacheInteractor.saveCalled)
        XCTAssertFalse(routineCacheInteractor.saveCalled)
    }
    
    func testSaveWorkout_ErrorLoadingCreatedWorkouts() {
        routineCacheInteractor.loadThrow = true
        XCTAssertThrowsError(try sut.saveWorkout(workout: WorkoutFixtures.legWorkout,
                                                 historyFilename: WorkoutFixtures.legWorkoutFilename))
        XCTAssertTrue(cacheInteractor.saveCalled)
        XCTAssertTrue(routineCacheInteractor.saveCalled)
    }
    
    func testSaveWorkout_ErrorSavingCreatedWorkout() {
        routineCacheInteractor.saveThrow = true
        routineCacheInteractor.stubData = WorkoutFixtures.loadedRoutines
        XCTAssertThrowsError(try sut.saveWorkout(workout: WorkoutFixtures.legWorkout,
                                                 historyFilename: WorkoutFixtures.legWorkoutFilename))
        XCTAssertTrue(cacheInteractor.saveCalled)
        XCTAssertTrue(routineCacheInteractor.saveCalled)
    }
    
    func testSaveWorkout_Success() throws {
        routineCacheInteractor.stubFileExists = true
        routineCacheInteractor.stubData = WorkoutFixtures.loadedRoutines
        try sut.saveWorkout(workout: WorkoutFixtures.legWorkout,
                            historyFilename: WorkoutFixtures.legWorkoutFilename,
                            planId: WorkoutFixtures.myPlanId)
        XCTAssertTrue(cacheInteractor.saveCalled)
        XCTAssertTrue(routineCacheInteractor.saveCalled)
    }
}
