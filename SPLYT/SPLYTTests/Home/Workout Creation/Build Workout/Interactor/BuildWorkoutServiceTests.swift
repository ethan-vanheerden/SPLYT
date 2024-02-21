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
    private var mockAPIInteractor: MockAPIInteractor.Type!
    private var mockUserSettings: MockUserSettings!
    private var mockUserAuth: MockUserAuth!
    private var mockDate: Date!
    private var sut: BuildWorkoutService!
    
    override func setUp() async throws {
        MockAPIInteractor.reset()
        self.cacheInteractor = MockCacheInteractor()
        self.routineCacheInteractor = MockCacheInteractor()
        let routineService = CreatedRoutinesService(cacheInteractor: routineCacheInteractor)
        self.mockAPIInteractor = MockAPIInteractor.self
        self.mockUserSettings = MockUserSettings()
        self.mockUserAuth = MockUserAuth()
        self.mockDate = WorkoutFixtures.dec_27_2022_1000
        self.sut = BuildWorkoutService(cacheInteractor: cacheInteractor,
                                       routineService: routineService,
                                       apiInteractor: mockAPIInteractor,
                                       userSettings: mockUserSettings,
                                       userAuth: mockUserAuth,
                                       currentDate: mockDate)
    }
    
    func testLoadExercises_NoSyncDate_NetworkError_LoadsFromCache() async throws {
        mockUserSettings.mockDefaults[.lastSyncedExercises] = nil
        mockAPIInteractor.shouldThrow = true
        cacheInteractor.stubFileExists = true
        cacheInteractor.stubData = Fixtures.backSquatNoneSelectedMap
        
        let result = try await sut.loadAvailableExercises()
        
        XCTAssertEqual(result, Fixtures.backSquatNoneSelectedMap)
        XCTAssertTrue(mockAPIInteractor.called)
        // Only updates cache when we get network data
        XCTAssertFalse(cacheInteractor.saveCalled)
        XCTAssertNil(mockUserSettings.mockDefaults[.lastSyncedExercises])
    }
    
    func testLoadExercises_NoSyncDate_UpdateCacheError() async throws {
        mockUserSettings.mockDefaults[.lastSyncedExercises] = nil
        mockAPIInteractor.mockResponses = [
            Fixtures.availableExerciseResponse,
            Fixtures.favoritesResponse
        ]
        cacheInteractor.stubFileExists = true
        cacheInteractor.stubData = Fixtures.backSquatNoneSelectedMap
        cacheInteractor.saveThrow = true
        
        let result = try await sut.loadAvailableExercises()
        
        // Since the cache save throws, it is not updated with the network data
        XCTAssertEqual(result, Fixtures.backSquatNoneSelectedMap)
        XCTAssertTrue(mockAPIInteractor.called)
        XCTAssertTrue(cacheInteractor.saveCalled)
        XCTAssertNil(mockUserSettings.mockDefaults[.lastSyncedExercises])
    }
    
    func testLoadExercises_NoSyncDate_Success() async throws {
        mockUserSettings.mockDefaults[.lastSyncedExercises] = nil
        mockAPIInteractor.mockResponses = [
            Fixtures.availableExerciseResponse,
            Fixtures.favoritesResponse
        ]
        cacheInteractor.stubFileExists = true
        cacheInteractor.stubData = Fixtures.backSquatNoneSelectedMap
        
        let result = try await sut.loadAvailableExercises()
        let exerciseMap = [
            WorkoutFixtures.backSquatId: Fixtures.backSquatAvailable(selectedGroups: [], isFavorite: true),
            WorkoutFixtures.benchPressId: Fixtures.benchPressAvailable(selectedGroups: [], isFavorite: false),
            WorkoutFixtures.inclineRowId: Fixtures.inclineDBRowAvailable(selectedGroups: [], isFavorite: false)
        ]
        
        // Updated with the network data (including favorites)
        XCTAssertEqual(result, exerciseMap)
        XCTAssertTrue(mockAPIInteractor.called)
        XCTAssertTrue(cacheInteractor.saveCalled)
        XCTAssertNotNil(mockUserSettings.mockDefaults[.lastSyncedExercises])
    }
    
    func testLoadExercises_SyncDateExpired_NetworkCall() async throws {
        mockUserSettings.mockDefaults[.lastSyncedExercises] = Date.distantPast
        mockAPIInteractor.mockResponses = [
            Fixtures.availableExerciseResponse,
            Fixtures.favoritesResponse
        ]
        cacheInteractor.stubFileExists = true
        cacheInteractor.stubData = Fixtures.backSquatNoneSelectedMap
        
        let result = try await sut.loadAvailableExercises()
        let exerciseMap = [
            WorkoutFixtures.backSquatId: Fixtures.backSquatAvailable(selectedGroups: [], isFavorite: true),
            WorkoutFixtures.benchPressId: Fixtures.benchPressAvailable(selectedGroups: [], isFavorite: false),
            WorkoutFixtures.inclineRowId: Fixtures.inclineDBRowAvailable(selectedGroups: [], isFavorite: false)
        ]
        
        XCTAssertEqual(result, exerciseMap)
        XCTAssertTrue(mockAPIInteractor.called)
        XCTAssertTrue(cacheInteractor.saveCalled)
        XCTAssertEqual(mockUserSettings.mockDefaults[.lastSyncedExercises] as! Date, WorkoutFixtures.dec_27_2022_1000)
    }
    
    func testLoadExercises_NoSyncNeeded_LoadFromCache() async throws {
        mockUserSettings.mockDefaults[.lastSyncedExercises] = WorkoutFixtures.dec_27_2022_1000
        mockAPIInteractor.mockResponses = [
            Fixtures.availableExerciseResponse,
            Fixtures.favoritesResponse
        ]
        cacheInteractor.stubFileExists = true
        cacheInteractor.stubData = Fixtures.backSquatNoneSelectedMap
        
        let result = try await sut.loadAvailableExercises()
        
        XCTAssertEqual(result, Fixtures.backSquatNoneSelectedMap)
        XCTAssertFalse(mockAPIInteractor.called)
        XCTAssertFalse(cacheInteractor.saveCalled)
        XCTAssertEqual(mockUserSettings.mockDefaults[.lastSyncedExercises] as! Date, WorkoutFixtures.dec_27_2022_1000)
    }
    
    func testLoadExercises_NoSync_FileNoExist_LoadsAndSavesFallback_ErrorSaving() async throws {
        mockUserSettings.mockDefaults[.lastSyncedExercises] = WorkoutFixtures.dec_27_2022_1000
        cacheInteractor.saveThrow = true
        
        await assertThrowsAsyncError(try await sut.loadAvailableExercises())
        XCTAssertFalse(mockAPIInteractor.called)
    }
    
    func testLoadExercises_NoSync_FileNoExist_LoadsAndSavesFallback_Success() async throws {
        mockUserSettings.mockDefaults[.lastSyncedExercises] = WorkoutFixtures.dec_27_2022_1000
        cacheInteractor.stubFileExists = false
        
        let exercises = try await sut.loadAvailableExercises()
        XCTAssertFalse(exercises.isEmpty)
        XCTAssertTrue(cacheInteractor.saveCalled)
        XCTAssertFalse(mockAPIInteractor.called)
    }
    
    func testLoadExercises_No_Sync_FileExists_LoadsFromCache_ErrorLoading() async throws {
        mockUserSettings.mockDefaults[.lastSyncedExercises] = WorkoutFixtures.dec_27_2022_1000
        cacheInteractor.stubFileExists = true
        cacheInteractor.loadThrow = true
        
        await assertThrowsAsyncError(try await sut.loadAvailableExercises())
        XCTAssertFalse(mockAPIInteractor.called)
    }
    
    func testLoadExercises_NoSync_FileExists_LoadsFromCache_Success() async throws {
        mockUserSettings.mockDefaults[.lastSyncedExercises] = WorkoutFixtures.dec_27_2022_1000
        cacheInteractor.stubFileExists = true
        let stubData = Fixtures.loadedExercisesNoneSelectedMap
        cacheInteractor.stubData = stubData
        
        let exercises = try await sut.loadAvailableExercises()
        XCTAssertEqual(exercises, stubData)
        XCTAssertFalse(mockAPIInteractor.called)
    }
    
    func testToggleFavorite_NetworkError() async throws {
        mockAPIInteractor.shouldThrow = true

        await assertThrowsAsyncError(try await sut.toggleFavorite(exerciseId: "id", isFavorite: true))
        
        XCTAssertTrue(mockAPIInteractor.called)
        XCTAssertFalse(cacheInteractor.saveCalled)
    }
    
    func testToggleFavorite_Success() async throws {
        mockAPIInteractor.mockResponses = [
            Fixtures.favoritesResponse
        ]

        try await sut.toggleFavorite(exerciseId: "id", isFavorite: true)
        
        XCTAssertTrue(mockAPIInteractor.called)
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
