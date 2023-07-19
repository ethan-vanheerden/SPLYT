//
//  HomeServiceTests.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 3/6/23.
//

import XCTest
@testable import SPLYT
import Mocking
@testable import ExerciseCore

final class HomeServiceTests: XCTestCase {
    typealias WorkoutFixtures = WorkoutModelFixtures
    private var cacheInteractor: MockCacheInteractor!
    private var routineCacheInteractor: MockCacheInteractor!
    private var sut: HomeService!
    private let emptyRoutines = CreatedRoutines(workouts: [:],
                                                plans: [:])
    
    override func setUpWithError() throws {
        self.cacheInteractor = MockCacheInteractor()
        self.routineCacheInteractor = MockCacheInteractor()
        let routineService = CreatedRoutinesService(cacheInteractor: routineCacheInteractor)
        self.sut = HomeService(cacheInteractor: cacheInteractor,
                               routineService: routineService)
    }
    
    func testLoadRoutines_FileNoExist_SaveError() {
        routineCacheInteractor.saveThrow = true
        
        XCTAssertThrowsError(try sut.loadRoutines())
        XCTAssertTrue(routineCacheInteractor.saveCalled)
    }
    
    func testLoadRoutines_FileNoExist_LoadError() {
        routineCacheInteractor.loadThrow = true
        
        XCTAssertThrowsError(try sut.loadRoutines())
        XCTAssertTrue(routineCacheInteractor.saveCalled)
    }
    
    func testLoadRoutines_FileNoExist_LoadsEmptyList() throws {
        let result = try sut.loadRoutines()
        
        XCTAssertEqual(result, emptyRoutines)
        XCTAssertTrue(routineCacheInteractor.saveCalled)
    }
    
    func testLoadRoutines_FileExists_LoadError() {
        routineCacheInteractor.stubFileExists = true
        routineCacheInteractor.loadThrow = true
        
        XCTAssertThrowsError(try sut.loadRoutines())
        XCTAssertFalse(routineCacheInteractor.saveCalled)
    }
    
    func testLoadRoutines_FileExists_Success() throws {
        routineCacheInteractor.stubFileExists = true
        let routines = WorkoutFixtures.loadedRoutines
        routineCacheInteractor.stubData = routines
        
        let result = try sut.loadRoutines()
        
        XCTAssertEqual(result, routines)
        XCTAssertFalse(routineCacheInteractor.saveCalled)
    }
    
    func testSaveRoutines_SaveError() {
        routineCacheInteractor.saveThrow = true
        
        XCTAssertThrowsError(try sut.saveRoutines(emptyRoutines))
        XCTAssertTrue(routineCacheInteractor.saveCalled)
    }
    
    func testSaveRoutines_Success() throws {
        routineCacheInteractor.stubFileExists = true
        let routines = WorkoutFixtures.loadedRoutines
        
        try sut.saveRoutines(routines)
        let result = try sut.loadRoutines() // Load the saved routines
        
        XCTAssertEqual(result, routines)
        XCTAssertTrue(routineCacheInteractor.saveCalled)
    }
    
    func testDeleteWorkoutHistory_LoadError() {
        cacheInteractor.stubFileExists = true
        cacheInteractor.loadThrow = true
        
        XCTAssertThrowsError(try sut.deleteWorkoutHistory(workoutId: WorkoutFixtures.legWorkoutId))
    }
    
    func testDeleteWorkoutHistory_FileNoExist_DoesNothing() throws {
        try sut.deleteWorkoutHistory(workoutId: WorkoutFixtures.legWorkoutId)
        XCTAssertFalse(cacheInteractor.saveCalled)
    }
    
    func testDeleteWorkoutHistory_Success() throws {
        cacheInteractor.stubFileExists = true
        cacheInteractor.stubData = [WorkoutFixtures.legWorkout, WorkoutFixtures.fullBodyWorkout]
        
        try sut.deleteWorkoutHistory(workoutId: WorkoutFixtures.legWorkoutId)
        
        let savedWorkouts = cacheInteractor.stubData as? [Workout]
        let expectedWorkouts = [WorkoutFixtures.fullBodyWorkout]
        
        XCTAssertEqual(savedWorkouts, expectedWorkouts)
        XCTAssertTrue(cacheInteractor.saveCalled)
    }
}
