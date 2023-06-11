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
    private var workoutCacheInteractor: MockCacheInteractor!
    private var sut: DoWorkoutService!
    
    override func setUpWithError() throws {
        cacheInteractor = MockCacheInteractor()
        workoutCacheInteractor = MockCacheInteractor()
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
    
    func testLoadWorkout_FileExists_ErrorLoading() {
        cacheInteractor.stubFileExists = true
        cacheInteractor.loadThrow = true
        XCTAssertThrowsError(try sut.loadWorkout(filename: WorkoutFixtures.legWorkoutFilename, workoutId: WorkoutFixtures.legWorkoutId))
    }
    
    func testLoadWorkout_FileExists_NoWorkoutsFound() {
        cacheInteractor.stubFileExists = true
        cacheInteractor.stubData = [Workout]()
        XCTAssertThrowsError(try sut.loadWorkout(filename: WorkoutFixtures.legWorkoutFilename, workoutId: WorkoutFixtures.legWorkoutId))
    }
    
    func testLoadWorkout_FileExists_Success() throws {
        cacheInteractor.stubFileExists = true
        cacheInteractor.stubData = [WorkoutFixtures.legWorkout]
        
        let result = try sut.loadWorkout(filename: WorkoutFixtures.legWorkoutFilename,
                                         workoutId: WorkoutFixtures.legWorkoutId)
        
        XCTAssertEqual(result, WorkoutFixtures.legWorkout)
    }
    
    func testSaveWorkout_FileNoExist_ErrorSaving() {
        cacheInteractor.saveThrow = true
        XCTAssertThrowsError(try sut.saveWorkout(workout: WorkoutFixtures.legWorkout, filename: WorkoutFixtures.legWorkoutFilename))
        XCTAssertTrue(cacheInteractor.saveCalled)
        XCTAssertFalse(workoutCacheInteractor.saveCalled)
    }
    
    func testSaveWorkout_FileExist_ErrorLoading() {
        cacheInteractor.stubFileExists = true
        cacheInteractor.loadThrow = true
        XCTAssertThrowsError(try sut.saveWorkout(workout: WorkoutFixtures.legWorkout, filename: WorkoutFixtures.legWorkoutFilename))
        XCTAssertFalse(cacheInteractor.saveCalled)
        XCTAssertFalse(workoutCacheInteractor.saveCalled)
    }
    
    func testSaveWorkout_FileExist_ErrorSaving() {
        cacheInteractor.stubFileExists = true
        cacheInteractor.stubData = [WorkoutFixtures.legWorkout]
        cacheInteractor.saveThrow = true
        XCTAssertThrowsError(try sut.saveWorkout(workout: WorkoutFixtures.legWorkout, filename: WorkoutFixtures.legWorkoutFilename))
        XCTAssertTrue(cacheInteractor.saveCalled)
        XCTAssertFalse(workoutCacheInteractor.saveCalled)
    }
    
    func testSaveWorkout_ErrorLoadingCreatedWorkouts() {
        workoutCacheInteractor.loadThrow = true
        XCTAssertThrowsError(try sut.saveWorkout(workout: WorkoutFixtures.legWorkout, filename: WorkoutFixtures.legWorkoutFilename))
        XCTAssertTrue(cacheInteractor.saveCalled)
        XCTAssertTrue(workoutCacheInteractor.saveCalled)
    }
    
    func testSaveWorkout_ErrorSavingCreatedWorkout() {
        workoutCacheInteractor.stubData = WorkoutFixtures.loadedCreatedWorkouts
        workoutCacheInteractor.saveThrow = true
        XCTAssertThrowsError(try sut.saveWorkout(workout: WorkoutFixtures.legWorkout, filename: WorkoutFixtures.legWorkoutFilename))
        XCTAssertTrue(cacheInteractor.saveCalled)
        XCTAssertTrue(workoutCacheInteractor.saveCalled)
    }
    
    func testSaveWorkout_Success() throws {
        workoutCacheInteractor.stubFileExists = true
        workoutCacheInteractor.stubData = WorkoutFixtures.loadedCreatedWorkouts
        try sut.saveWorkout(workout: WorkoutFixtures.legWorkout,
                            filename: WorkoutFixtures.legWorkoutFilename)
        XCTAssertTrue(cacheInteractor.saveCalled)
        XCTAssertTrue(workoutCacheInteractor.saveCalled)
    }
    
}
