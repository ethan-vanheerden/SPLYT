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
    typealias Fixtures = HomeFixtures
    private var cacheInteractor: MockCacheInteractor.Type!
    private var sut: HomeService!
    
    override func setUpWithError() throws {
        self.cacheInteractor = MockCacheInteractor.self
        sut = HomeService(cacheInteractor: cacheInteractor)
    }
    
    func testLoadWorkouts_FileNoExist_SaveError() {
        cacheInteractor.saveThrow = true
        
        XCTAssertThrowsError(try sut.loadWorkouts())
        XCTAssertTrue(cacheInteractor.saveCalled)
    }
    
    func testLoadWorkouts_FileNoExist_LoadError() {
        cacheInteractor.loadThrow = true
        
        XCTAssertThrowsError(try sut.loadWorkouts())
        XCTAssertTrue(cacheInteractor.saveCalled)
    }
    
    func testLoadWorkouts_FileNoExist_LoadsEmptyList() throws {
        let result = try sut.loadWorkouts()
        
        XCTAssertEqual(result, [:])
        XCTAssertTrue(cacheInteractor.saveCalled)
    }
    
    func testLoadWorkouts_FileExists_LoadError() {
        cacheInteractor.stubFileExists = true
        cacheInteractor.loadThrow = true
        
        XCTAssertThrowsError(try sut.loadWorkouts())
        XCTAssertFalse(cacheInteractor.saveCalled)
    }
    
    func testLoadWorkouts_FileExists_Success() throws {
        cacheInteractor.stubFileExists = true
        let workouts = Fixtures.loadedCreatedWorkouts
        cacheInteractor.stubData = workouts
        
        let result = try sut.loadWorkouts()
        
        XCTAssertEqual(result, workouts)
        XCTAssertFalse(cacheInteractor.saveCalled)
    }
    
    func testSaveWorkouts_SaveError() {
        cacheInteractor.saveThrow = true
        
        XCTAssertThrowsError(try sut.saveWorkouts([:]))
        XCTAssertTrue(cacheInteractor.saveCalled)
    }
    
    func testSaveWorkouts_Success() throws {
        cacheInteractor.stubFileExists = true
        let workouts = Fixtures.loadedCreatedWorkouts
        
        try sut.saveWorkouts(workouts)
        let result = try sut.loadWorkouts() // Load the saved workouts
        
        XCTAssertEqual(result, workouts)
        XCTAssertTrue(cacheInteractor.saveCalled)
    }
}
