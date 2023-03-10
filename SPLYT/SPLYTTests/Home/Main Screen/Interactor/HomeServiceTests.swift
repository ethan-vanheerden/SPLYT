//
//  HomeServiceTests.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 3/6/23.
//

import XCTest
@testable import SPLYT
import Mocking

final class HomeServiceTests: XCTestCase {
    typealias WorkoutCache = MockCacheInteractor<CreatedWorkoutsCacheRequest>
    typealias Fixtures = HomeFixtures
    private var sut: HomeService<WorkoutCache>!
    private var workoutCache: WorkoutCache!
    
    override func setUpWithError() throws {
        self.workoutCache = MockCacheInteractor(request: CreatedWorkoutsCacheRequest())
        sut = HomeService(cacheInteractor: workoutCache)
    }
    
    func testLoadWorkouts_FileNoExist_SaveError() {
        workoutCache.saveThrow = true
        
        XCTAssertThrowsError(try sut.loadWorkouts())
        XCTAssertTrue(workoutCache.saveCalled)
    }
    
    func testLoadWorkouts_FileNoExist_LoadError() {
        workoutCache.loadThrow = true
        
        XCTAssertThrowsError(try sut.loadWorkouts())
        XCTAssertTrue(workoutCache.saveCalled)
    }
    
    func testLoadWorkouts_FileNoExist_LoadsEmptyList() throws {
        let result = try sut.loadWorkouts()
        
        XCTAssertEqual(result, [])
        XCTAssertTrue(workoutCache.saveCalled)
    }
    
    func testLoadWorkouts_FileExists_LoadError() {
        workoutCache.stubFileExists = true
        workoutCache.loadThrow = true
        
        XCTAssertThrowsError(try sut.loadWorkouts())
        XCTAssertFalse(workoutCache.saveCalled)
    }
    
    func testLoadWorkouts_FileExists_Success() throws {
        workoutCache.stubFileExists = true
        let workouts = Fixtures.loadedWorkouts
        workoutCache.stubData = workouts
        
        let result = try sut.loadWorkouts()
        
        XCTAssertEqual(result, workouts)
        XCTAssertFalse(workoutCache.saveCalled)
    }
    
    func testSaveWorkouts_SaveError() {
        workoutCache.saveThrow = true
        
        XCTAssertThrowsError(try sut.saveWorkouts([]))
        XCTAssertTrue(workoutCache.saveCalled)
    }
    
    func testSaveWorkouts_Success() throws {
        workoutCache.stubFileExists = true
        let workouts = Fixtures.loadedWorkouts
        
        try sut.saveWorkouts(workouts)
        let result = try sut.loadWorkouts() // Load the saved workouts
        
        XCTAssertEqual(result, workouts)
        XCTAssertTrue(workoutCache.saveCalled)
    }
}
