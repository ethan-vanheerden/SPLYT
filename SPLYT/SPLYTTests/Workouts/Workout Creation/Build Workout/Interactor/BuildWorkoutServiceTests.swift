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
    typealias Cache = MockCacheInteractor<AvailableExercisesCacheRequest>
    typealias Fixtures = BuildWorkoutFixtures
    private var sut: BuildWorkoutService<Cache>!
    private var mockCache: Cache!
    
    override func setUp() async throws {
        self.mockCache = MockCacheInteractor(request: AvailableExercisesCacheRequest())
        self.sut = BuildWorkoutService(cacheInteractor: mockCache)
    }
    
    func testLoadExercises_FileNoExist_LoadsAndSavesFallback_ErrorSaving() throws {
        mockCache.stubFileExists = false
        mockCache.shouldThrow = true
        
        XCTAssertThrowsError(try sut.loadAvailableExercises())
    }
    
    func testLoadExercises_FileNoExist_LoadsAndSavesFallback_Success() throws {
        mockCache.stubFileExists = false
        
        let exercises = try sut.loadAvailableExercises()
        XCTAssertFalse(exercises.isEmpty)
        XCTAssertTrue(mockCache.saveCalled)
    }
    
    func testLoadExercises_FileExists_LoadsFromCache_ErrorLoading() throws {
        mockCache.stubFileExists = true
        mockCache.shouldThrow = true

        XCTAssertThrowsError(try sut.loadAvailableExercises())
    }
    
    func testLoadExercises_FileExists_LoadsFromCache_Success() throws {
        mockCache.stubFileExists = true
        let stubData = Fixtures.loadedExercisesNoneSelected
        mockCache.stubData = stubData
        
        let exercises = try sut.loadAvailableExercises()
        XCTAssertEqual(exercises, stubData)
    }
    
    func testSaveExercises_ErrorSaving() throws {
        mockCache.shouldThrow = true
        let stubData = Fixtures.loadedExercisesNoneSelected
        
        XCTAssertThrowsError(try sut.saveAvailableExercises(stubData))
        XCTAssertTrue(mockCache.saveCalled)
    }
    
    func testSaveExercises_Success() throws {
        let stubData = Fixtures.loadedExercisesNoneSelected
        
        XCTAssertNoThrow(try sut.saveAvailableExercises(stubData))
        XCTAssertTrue(mockCache.saveCalled)
    }
}
