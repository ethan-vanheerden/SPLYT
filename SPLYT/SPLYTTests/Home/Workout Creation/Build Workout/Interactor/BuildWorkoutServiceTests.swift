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
    // TODO: mock API interactor
    private var mockUserSettings: MockUserSettings!
    private var mockUserAuth: MockUserAuth!
    private var mockDate: Date!
    private var sut: BuildWorkoutService!
    
    override func setUp() async throws {
        self.cacheInteractor = MockCacheInteractor()
        self.routineCacheInteractor = MockCacheInteractor()
        let routineService = CreatedRoutinesService(cacheInteractor: routineCacheInteractor)
        self.mockUserSettings = MockUserSettings()
        self.mockUserAuth = MockUserAuth()
        self.mockDate = Date.distantPast
        self.sut = BuildWorkoutService(cacheInteractor: cacheInteractor,
                                       routineService: routineService,
                                       apiInteractor: "mock here",
                                       userSettings: mockUserSettings,
                                       userAuth: mockUserAuth,
                                       currentDate: mockDate)
    }
    
    func testLoadExercises_FileNoExist_LoadsAndSavesFallback_ErrorSaving() async throws {
        cacheInteractor.saveThrow = true
        
        await assertThrowsAsyncError(try await sut.loadAvailableExercises())
        
        //        XCTAssertThrowsError(try await sut.loadAvailableExercises())
    }
    
    func testLoadExercises_FileNoExist_LoadsAndSavesFallback_Success() async throws {
        cacheInteractor.stubFileExists = false
        
        let exercises = try await sut.loadAvailableExercises()
        XCTAssertFalse(exercises.isEmpty)
        XCTAssertTrue(cacheInteractor.saveCalled)
    }
    
    func testLoadExercises_FileExists_LoadsFromCache_ErrorLoading() async throws {
        cacheInteractor.stubFileExists = true
        cacheInteractor.loadThrow = true
        
        //        XCTAssertThrowsError(await try sut.loadAvailableExercises())
        await assertThrowsAsyncError(try await sut.loadAvailableExercises())
    }
    
    func testLoadExercises_FileExists_LoadsFromCache_Success() async throws {
        cacheInteractor.stubFileExists = true
        let stubData = Fixtures.loadedExercisesNoneSelected
        cacheInteractor.stubData = stubData
        
        let exercises = try await sut.loadAvailableExercises()
        XCTAssertEqual(exercises, Fixtures.loadedExercisesNoneSelectedMap)
    }
    
    //    func testSaveExercises_ErrorSaving() throws {
    //        cacheInteractor.saveThrow = true
    //        let stubData = Fixtures.loadedExercisesNoneSelected
    //
    //        XCTAssertThrowsError(try sut.saveAvailableExercises(stubData))
    //        XCTAssertTrue(cacheInteractor.saveCalled)
    //    }
    //
    //    func testSaveExercises_Success() throws {
    //        let stubData = Fixtures.loadedExercisesNoneSelected
    //
    //        XCTAssertNoThrow(try sut.saveAvailableExercises(stubData))
    //        XCTAssertTrue(cacheInteractor.saveCalled)
    //    }
    
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
