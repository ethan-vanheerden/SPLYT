//
//  BuildWorkoutServiceTests.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 1/31/23.
//

import XCTest
@testable import SPLYT
import Mocking
@testable import ExerciseCore

final class BuildWorkoutServiceTests: XCTestCase {
    typealias Fixtures = BuildWorkoutFixtures
    typealias WorkoutFixtures = WorkoutModelFixtures
    private var cacheInteractor: MockCacheInteractor!
    private var workoutCacheInteractor: MockCacheInteractor!
    private var sut: BuildWorkoutService!
    
    override func setUp() async throws {
        self.cacheInteractor = MockCacheInteractor()
        self.workoutCacheInteractor = MockCacheInteractor()
        let workoutService = CreatedWorkoutsService(cacheInteractor: workoutCacheInteractor)
        self.sut = BuildWorkoutService(cacheInteractor: cacheInteractor,
                                       workoutService: workoutService)
    }
    
    func testLoadExercises_FileNoExist_LoadsAndSavesFallback_ErrorSaving() throws {
        cacheInteractor.saveThrow = true
        
        XCTAssertThrowsError(try sut.loadAvailableExercises())
    }
    
    func testLoadExercises_FileNoExist_LoadsAndSavesFallback_Success() throws {
        cacheInteractor.stubFileExists = false
        
        let exercises = try sut.loadAvailableExercises()
        XCTAssertFalse(exercises.isEmpty)
        XCTAssertTrue(cacheInteractor.saveCalled)
    }
    
    func testLoadExercises_FileExists_LoadsFromCache_ErrorLoading() throws {
        cacheInteractor.stubFileExists = true
        cacheInteractor.loadThrow = true
        
        XCTAssertThrowsError(try sut.loadAvailableExercises())
    }
    
    func testLoadExercises_FileExists_LoadsFromCache_Success() throws {
        cacheInteractor.stubFileExists = true
        let stubData = Fixtures.loadedExercisesNoneSelected
        cacheInteractor.stubData = stubData
        
        let exercises = try sut.loadAvailableExercises()
        XCTAssertEqual(exercises, Fixtures.loadedExercisesNoneSelectedMap)
    }
    
    func testSaveExercises_ErrorSaving() throws {
        cacheInteractor.saveThrow = true
        let stubData = Fixtures.loadedExercisesNoneSelected
        
        XCTAssertThrowsError(try sut.saveAvailableExercises(stubData))
        XCTAssertTrue(cacheInteractor.saveCalled)
    }
    
    func testSaveExercises_Success() throws {
        let stubData = Fixtures.loadedExercisesNoneSelected
        
        XCTAssertNoThrow(try sut.saveAvailableExercises(stubData))
        XCTAssertTrue(cacheInteractor.saveCalled)
    }
    
    func testSaveWorkout_FileNoExist_ErrorSaving() {
        workoutCacheInteractor.saveThrow = true
        XCTAssertThrowsError(try sut.saveWorkout(WorkoutFixtures.legWorkout))
        XCTAssertTrue(workoutCacheInteractor.saveCalled)
    }
    
    func testSaveWorkout_FileNoExist_Success() {
        XCTAssertNoThrow(try sut.saveWorkout(WorkoutFixtures.legWorkout))
        XCTAssertTrue(workoutCacheInteractor.saveCalled)
    }
    
    func testSaveWorkout_FileExists_ErrorLoadingWorkouts() {
        workoutCacheInteractor.stubFileExists = true
        XCTAssertThrowsError(try sut.saveWorkout(WorkoutFixtures.legWorkout))
        XCTAssertFalse(cacheInteractor.saveCalled)
    }
    
    func testSaveWorkout_FileExists_Success() {
        workoutCacheInteractor.stubFileExists = true
        workoutCacheInteractor.stubData = WorkoutFixtures.loadedCreatedWorkouts
        XCTAssertNoThrow(try sut.saveWorkout(WorkoutFixtures.legWorkout))
        XCTAssertTrue(workoutCacheInteractor.saveCalled)
    }
}
