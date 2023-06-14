//
//  CreatedWorkoutsServiceTests.swift
//  
//
//  Created by Ethan Van Heerden on 6/9/23.
//

import XCTest
import Mocking
@testable import ExerciseCore

final class CreatedWorkoutsServiceTests: XCTestCase {
    typealias Fixtures = WorkoutModelFixtures
    private var cacheInteractor: MockCacheInteractor!
    private var sut: CreatedWorkoutsService!
    private var stubData: [String: CreatedWorkout]!
    
    override func setUpWithError() throws {
        cacheInteractor = MockCacheInteractor()
        sut = CreatedWorkoutsService(cacheInteractor: cacheInteractor)
        stubData = ["leg-workout": Fixtures.createdLegWorkout]
    }
    
    func testLoadWorkouts_FileExistError() {
        cacheInteractor.fileExistsThrow = true
        XCTAssertThrowsError(try sut.loadWorkouts())
    }
    
    func testLoadWorkouts_FileNoExist_ErrorSaving() {
        cacheInteractor.saveThrow = true
        XCTAssertThrowsError(try sut.loadWorkouts())
        XCTAssertTrue(cacheInteractor.saveCalled)
    }
    
    func testLoadWorkouts_FileNoExist_ErrorLoading() {
        cacheInteractor.loadThrow = true
        XCTAssertThrowsError(try sut.loadWorkouts())
        XCTAssertTrue(cacheInteractor.saveCalled)
    }
    
    func testLoadWorkouts_FileNoExist_Success() throws {
        let result = try sut.loadWorkouts()
        XCTAssertEqual(result, [:])
    }
    
    func testLoadWorkouts_FileExists_Success() throws {
        cacheInteractor.stubData = stubData
        cacheInteractor.stubFileExists = true
        let result = try sut.loadWorkouts()
        
        XCTAssertEqual(result, stubData)
    }
    
    func testLoadWorkout_ErrorLoading() {
        cacheInteractor.loadThrow = true
        XCTAssertThrowsError(try sut.loadWorkout(id: "leg-workout"))
    }
    
    func testLoadWorkout_WorkoutNoExist_Error() {
        cacheInteractor.stubData = stubData
        cacheInteractor.stubFileExists = true
        XCTAssertThrowsError(try sut.loadWorkout(id: "no_exist"))
    }
    
    func testLoadWorkout_Success() throws {
        cacheInteractor.stubData = stubData
        cacheInteractor.stubFileExists = true
        let result = try sut.loadWorkout(id: "leg-workout")
        
        XCTAssertEqual(result, Fixtures.createdLegWorkout)
    }
    
    func testSaveWorkouts_Error() {
        cacheInteractor.saveThrow = true
        XCTAssertThrowsError(try sut.saveWorkouts([:]))
        XCTAssertTrue(cacheInteractor.saveCalled)
    }
    
    func testSaveWorkouts_Success() throws {
        try sut.saveWorkouts([:])
        XCTAssertTrue(cacheInteractor.saveCalled)
        
        cacheInteractor.stubFileExists = true
        let workouts = try sut.loadWorkouts()
        
        XCTAssertEqual(workouts, [:])
    }
    
    func testSaveWorkout_ErrorLoading() {
        cacheInteractor.stubFileExists = true
        cacheInteractor.loadThrow = true
        XCTAssertThrowsError(try sut.saveWorkout(Fixtures.createdFullBodyWorkout))
        XCTAssertFalse(cacheInteractor.saveCalled)
    }
    
    func testSaveWorkout_ErrorSaving() {
        cacheInteractor.saveThrow = true
        XCTAssertThrowsError(try sut.saveWorkout(Fixtures.createdFullBodyWorkout))
        XCTAssertTrue(cacheInteractor.saveCalled)
    }
    
    func testSaveWorkout_Success() throws {
        cacheInteractor.stubFileExists = true
        cacheInteractor.stubData = stubData
        
        try sut.saveWorkout(Fixtures.createdFullBodyWorkout)
        XCTAssertTrue(cacheInteractor.saveCalled)
        
        let workouts = try sut.loadWorkouts()

        XCTAssertEqual(workouts, Fixtures.loadedCreatedWorkouts)
    }
}
