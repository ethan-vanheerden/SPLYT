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
    private var routineCacheInteractor: MockCacheInteractor!
    private var sut: BuildWorkoutService!
    
    override func setUp() async throws {
        self.cacheInteractor = MockCacheInteractor()
        self.routineCacheInteractor = MockCacheInteractor()
        let routineService = CreatedRoutinesService(cacheInteractor: routineCacheInteractor)
        self.sut = BuildWorkoutService(cacheInteractor: cacheInteractor,
                                       routineService: routineService)
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
        routineCacheInteractor.saveThrow = true
        XCTAssertThrowsError(try sut.saveWorkout(WorkoutFixtures.legWorkout))
        XCTAssertTrue(routineCacheInteractor.saveCalled)
    }
    
    func testSaveWorkout_FileNoExist_Success() {
        XCTAssertNoThrow(try sut.saveWorkout(WorkoutFixtures.legWorkout))
        XCTAssertTrue(routineCacheInteractor.saveCalled)
    }
    
    func testSaveWorkout_FileExists_ErrorLoadingWorkouts() {
        routineCacheInteractor.stubFileExists = true
        XCTAssertThrowsError(try sut.saveWorkout(WorkoutFixtures.legWorkout))
        XCTAssertFalse(cacheInteractor.saveCalled)
    }
    
    func testSaveWorkout_FileExists_Success() {
        routineCacheInteractor.stubFileExists = true
        routineCacheInteractor.stubData = WorkoutFixtures.loadedRoutines
        XCTAssertNoThrow(try sut.saveWorkout(WorkoutFixtures.legWorkout))
        XCTAssertTrue(routineCacheInteractor.saveCalled)
    }
}
