//
//  HomeInteractorTests.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 12/29/22.
//

import XCTest
@testable import SPLYT

final class HomeInteractorTests: XCTestCase {
    typealias Fixtures = HomeFixtures
    private var mockService: MockHomeService!
    private var sut: HomeInteractor!

    override func setUp() async throws {
        self.mockService = MockHomeService()
        self.sut = HomeInteractor(service: mockService)
    }
    
    func testInteract_Load_ServiceError() async {
        mockService.loadWorkoutsThrow = true
        let result = await sut.interact(with: .load)
        
        XCTAssertEqual(result, .error)
    }
    
    func testInteract_Load_Success() async {
        let result = await sut.interact(with: .load)
        let expectedDomain = HomeDomain(workouts: Fixtures.loadedWorkouts)
        
        XCTAssertEqual(result, .loaded(expectedDomain))
    }
    
    func testInteract_DeleteWorkout_NoSavedDomain_Error() async {
        let result = await sut.interact(with: .deleteWorkout(id: "leg-workout"))
        
        XCTAssertEqual(result, .error)
    }
    
    func testInteract_DeleteWorkout_ServiceError() async {
        await load()
        mockService.saveWorkoutsThrow = true
        let result = await sut.interact(with: .deleteWorkout(id: "leg-workout"))
        
        XCTAssertEqual(result, .error)
        XCTAssertTrue(mockService.saveWorkoutsCalled)
    }
    
    func testInteract_DeleteWorkout_BadId_DoesNothing() async {
        await load()
        let result = await sut.interact(with: .deleteWorkout(id: "not-a-workout"))
        let expectedDomain = HomeDomain(workouts: Fixtures.loadedWorkouts)
        
        XCTAssertEqual(result, .loaded(expectedDomain))
        XCTAssertTrue(mockService.saveWorkoutsCalled)
    }
    
    func testInteract_DeleteWorkout_Success() async {
        await load()
        let result = await sut.interact(with: .deleteWorkout(id: "leg-workout"))
        let expectedDomain = HomeDomain(workouts: [Fixtures.fullBodyWorkout])
        
        XCTAssertEqual(result, .loaded(expectedDomain))
        XCTAssertTrue(mockService.saveWorkoutsCalled)
    }
}

// MARK: - Private

private extension HomeInteractorTests {
    @discardableResult
    func load() async -> HomeDomainResult {
        return await sut.interact(with: .load)
    }
}
