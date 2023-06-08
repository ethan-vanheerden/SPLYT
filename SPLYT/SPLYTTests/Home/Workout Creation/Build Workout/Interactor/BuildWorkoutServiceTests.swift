//
//  BuildWorkoutServiceTests.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 1/31/23.
//

import XCTest
@testable import SPLYT
import Mocking

final class BuildWorkoutServiceTests: XCTestCase {
    typealias Fixtures = BuildWorkoutFixtures
    private var cacheInteractor = MockCacheInteractor.self
    private var sut: BuildWorkoutService!
    
    override func setUp() async throws {
        cacheInteractor.reset()
        self.sut = BuildWorkoutService(cacheInteractor: cacheInteractor)
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
        cacheInteractor.saveThrow = true
        XCTAssertThrowsError(try sut.saveWorkout(HomeFixtures.legWorkout))
        XCTAssertTrue(cacheInteractor.saveCalled)
    }
    
    func testSaveWorkout_FileNoExist_Success() {
        XCTAssertNoThrow(try sut.saveWorkout(HomeFixtures.legWorkout))
        XCTAssertTrue(cacheInteractor.saveCalled)
    }
    
    func testSaveWorkout_FileExists_ErrorLoadingWorkouts() {
        cacheInteractor.stubFileExists = true
        XCTAssertThrowsError(try sut.saveWorkout(HomeFixtures.legWorkout))
        XCTAssertFalse(cacheInteractor.saveCalled)
    }
    
    func testSaveWorkout_FileExists_Success() {
        cacheInteractor.stubFileExists = true
        cacheInteractor.stubData = HomeFixtures.loadedCreatedWorkouts
        XCTAssertNoThrow(try sut.saveWorkout(HomeFixtures.legWorkout))
        XCTAssertTrue(cacheInteractor.saveCalled)
    }
}
