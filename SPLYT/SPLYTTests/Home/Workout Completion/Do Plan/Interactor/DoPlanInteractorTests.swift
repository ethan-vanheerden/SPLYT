//
//  DoPlanInteractorTests.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 7/15/23.
//

import XCTest
@testable import SPLYT
@testable import ExerciseCore

final class DoPlanInteractorTests: XCTestCase {
    typealias WorkoutFixtures = WorkoutModelFixtures
    private var mockService: MockDoPlanService!
    private let legWorkoutId = WorkoutFixtures.legWorkoutId
    
    private var sut: DoPlanInteractor!

    override func setUpWithError() throws {
        mockService = MockDoPlanService()
        sut = DoPlanInteractor(planId: WorkoutFixtures.myPlanId,
                               service: mockService)
    }
    
    func testInteract_Load_ServiceError() async {
        mockService.loadPlanThrow = true
        let result = await sut.interact(with: .load)
        
        XCTAssertEqual(result, .error)
    }
    
    func testInteract_Load_Success() async {
        let result = await load()
        let expectedDomain = DoPlanDomain(plan: WorkoutFixtures.myPlan)
        
        XCTAssertEqual(result, .loaded(expectedDomain))
    }
    
    func testInteract_DeleteWorkout_NoSavedDomain_Error() async {
        let result = await sut.interact(with: .deleteWorkout(workoutId: legWorkoutId))
        
        XCTAssertEqual(result, .error)
        XCTAssertFalse(mockService.deleteWorkoutCalled)
    }
    
    func testInteract_DeleteWorkout_ServiceError() async {
        mockService.deleteWorkoutThrow = true
        await load()
        let result = await sut.interact(with: .deleteWorkout(workoutId: legWorkoutId))
        
        XCTAssertEqual(result, .error)
        XCTAssertTrue(mockService.deleteWorkoutCalled)
    }
    
    func testInteract_DeleteWorkout_Success() async {
        await load()
        let result = await sut.interact(with: .deleteWorkout(workoutId: legWorkoutId))
        
        var expectedPlan = WorkoutFixtures.myPlan
        expectedPlan.workouts.remove(at: 0)
        let expectedDomain = DoPlanDomain(plan: expectedPlan)
        
        XCTAssertEqual(result, .loaded(expectedDomain))
        XCTAssertTrue(mockService.deleteWorkoutCalled)
    }
}

// MARK: - Private

private extension DoPlanInteractorTests {
    @discardableResult
    func load() async -> DoPlanDomainResult {
        return await sut.interact(with: .load)
    }
}
