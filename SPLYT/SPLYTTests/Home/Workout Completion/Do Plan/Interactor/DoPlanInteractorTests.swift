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
        let result = await sut.interact(with: .load)
        let expectedDomain = DoPlanDomain(plan: WorkoutFixtures.myPlan)
        
        XCTAssertEqual(result, .loaded(expectedDomain))
    }
}
