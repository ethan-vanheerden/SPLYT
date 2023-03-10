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
    typealias ExerciseCache = MockCacheInteractor<AvailableExercisesCacheRequest>
    typealias WorkoutCache = MockCacheInteractor<CreatedWorkoutsCacheRequest>
    typealias Fixtures = BuildWorkoutFixtures
    private var sut: BuildWorkoutService<ExerciseCache, WorkoutCache>!
    private var exerciseCache: ExerciseCache!
    private var workoutCache: WorkoutCache!
    
    override func setUp() async throws {
        self.exerciseCache = MockCacheInteractor(request: AvailableExercisesCacheRequest())
        self.workoutCache = MockCacheInteractor(request: CreatedWorkoutsCacheRequest())
        self.sut = BuildWorkoutService(exerciseCacheInteractor: exerciseCache,
                                       workoutCacheInteractor: workoutCache)
    }
    
    func testLoadExercises_FileNoExist_LoadsAndSavesFallback_ErrorSaving() throws {
        exerciseCache.saveThrow = true
        
        XCTAssertThrowsError(try sut.loadAvailableExercises())
    }
    
    func testLoadExercises_FileNoExist_LoadsAndSavesFallback_Success() throws {
        exerciseCache.stubFileExists = false
        
        let exercises = try sut.loadAvailableExercises()
        XCTAssertFalse(exercises.isEmpty)
        XCTAssertTrue(exerciseCache.saveCalled)
    }
    
    func testLoadExercises_FileExists_LoadsFromCache_ErrorLoading() throws {
        exerciseCache.stubFileExists = true
        exerciseCache.loadThrow = true
        
        XCTAssertThrowsError(try sut.loadAvailableExercises())
    }
    
    func testLoadExercises_FileExists_LoadsFromCache_Success() throws {
        exerciseCache.stubFileExists = true
        let stubData = Fixtures.loadedExercisesNoneSelected
        exerciseCache.stubData = stubData
        
        let exercises = try sut.loadAvailableExercises()
        XCTAssertEqual(exercises, stubData)
    }
    
    func testSaveExercises_ErrorSaving() throws {
        exerciseCache.saveThrow = true
        let stubData = Fixtures.loadedExercisesNoneSelected
        
        XCTAssertThrowsError(try sut.saveAvailableExercises(stubData))
        XCTAssertTrue(exerciseCache.saveCalled)
    }
    
    func testSaveExercises_Success() throws {
        let stubData = Fixtures.loadedExercisesNoneSelected
        
        XCTAssertNoThrow(try sut.saveAvailableExercises(stubData))
        XCTAssertTrue(exerciseCache.saveCalled)
    }
    
    func testSaveWorkout_FileNoExist_ErrorSaving() {
        workoutCache.saveThrow = true
        XCTAssertThrowsError(try sut.saveWorkout(HomeFixtures.legWorkout))
        XCTAssertTrue(workoutCache.saveCalled)
    }
    
    func testSaveWorkout_FileNoExist_Success() {
        XCTAssertNoThrow(try sut.saveWorkout(HomeFixtures.legWorkout))
        XCTAssertTrue(workoutCache.saveCalled)
    }
    
    func testSaveWorkout_FileExists_ErrorLoadingWorkouts() {
        workoutCache.stubFileExists = true
        XCTAssertThrowsError(try sut.saveWorkout(HomeFixtures.legWorkout))
        XCTAssertFalse(workoutCache.saveCalled)
    }
    
    func testSaveWorkout_FileExists_Success() {
        workoutCache.stubFileExists = true
        workoutCache.stubData = [HomeFixtures.fullBodyWorkout]
        XCTAssertNoThrow(try sut.saveWorkout(HomeFixtures.legWorkout))
        XCTAssertTrue(workoutCache.saveCalled)
    }
}
