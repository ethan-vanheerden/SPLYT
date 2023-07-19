//
//  HomeInteractorTests.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 12/29/22.
//

import XCTest
@testable import SPLYT
@testable import ExerciseCore

final class HomeInteractorTests: XCTestCase {
    typealias WorkoutFixtures = WorkoutModelFixtures
    private var mockService: MockHomeService!
    private var sut: HomeInteractor!
    
    override func setUp() async throws {
        self.mockService = MockHomeService()
        self.sut = HomeInteractor(service: mockService)
    }
    
    func testInteract_Load_ServiceError() async {
        mockService.loadRoutinesThrow = true
        let result = await sut.interact(with: .load)
        
        XCTAssertEqual(result, .error)
    }
    
    func testInteract_Load_Success() async {
        let result = await sut.interact(with: .load)
        let expectedDomain = HomeDomain(routines: WorkoutFixtures.loadedRoutines)
        
        XCTAssertEqual(result, .loaded(expectedDomain))
    }
    
    func testInteract_DeleteWorkout_NoSavedDomain_Error() async {
        let result = await sut.interact(with: .deleteWorkout(id: WorkoutFixtures.legWorkoutId))
        XCTAssertEqual(result, .error)
    }
    
    func testInteract_DeleteWorkout_SaveRoutines_ServiceError() async {
        await load()
        mockService.saveRoutinesThrow = true
        let result = await sut.interact(with: .deleteWorkout(id: WorkoutFixtures.legWorkoutId))
        
        XCTAssertEqual(result, .error)
        XCTAssertTrue(mockService.saveRoutinesCalled)
        XCTAssertEqual(mockService.numWorkoutHistoryDeleted, 0)
    }
    
    func testInteract_DeleteWorkout_DeleteWorkoutHistory_ServiceError() async {
        await load()
        mockService.deleteWorkoutHistoryThrow = true
        let result = await sut.interact(with: .deleteWorkout(id: WorkoutFixtures.legWorkoutId))
        
        XCTAssertEqual(result, .error)
        XCTAssertTrue(mockService.saveRoutinesCalled)
        XCTAssertEqual(mockService.numWorkoutHistoryDeleted, 1)
    }
    
    func testInteract_DeleteWorkout_BadId_DoesNothing() async {
        await load()
        let result = await sut.interact(with: .deleteWorkout(id: "not-a-workout"))
        let expectedDomain = HomeDomain(routines: WorkoutFixtures.loadedRoutines)
        
        XCTAssertEqual(result, .loaded(expectedDomain))
        XCTAssertTrue(mockService.saveRoutinesCalled)
    }
    
    func testInteract_DeleteWorkout_Success() async {
        await load()
        let result = await sut.interact(with: .deleteWorkout(id: WorkoutFixtures.legWorkoutId))
        
        var routines = WorkoutFixtures.loadedRoutines
        routines.workouts.removeValue(forKey: WorkoutFixtures.legWorkoutId)
        let expectedDomain = HomeDomain(routines: routines)
        
        XCTAssertEqual(result, .loaded(expectedDomain))
        XCTAssertTrue(mockService.saveRoutinesCalled)
    }
    
    func testInteract_DeletePlan_NoSavedDomain_Error() async {
        let result = await sut.interact(with: .deletePlan(id: WorkoutFixtures.myPlanId))
        XCTAssertEqual(result, .error)
    }
    
    func testInteract_DeletePlan_PlanNoExist_Error() async {
        await load()
        let result = await sut.interact(with: .deletePlan(id: "bad-id"))
        
        XCTAssertEqual(result, .error)
    }
    
    func testInteract_DeletePlan_SaveRoutines_ServiceError() async {
        await load()
        mockService.saveRoutinesThrow = true
        let result = await sut.interact(with: .deletePlan(id: WorkoutFixtures.myPlanId))
        
        XCTAssertEqual(result, .error)
        XCTAssertTrue(mockService.saveRoutinesCalled)
        XCTAssertEqual(mockService.numWorkoutHistoryDeleted, 0)
    }
    
    func testInteract_DeletePlan_DeleteWorkoutHistory_ServiceError() async {
        await load()
        mockService.deleteWorkoutHistoryThrow = true
        let result = await sut.interact(with: .deletePlan(id: WorkoutFixtures.myPlanId))
        
        XCTAssertEqual(result, .error)
        XCTAssertTrue(mockService.saveRoutinesCalled)
        XCTAssertEqual(mockService.numWorkoutHistoryDeleted, 1)
    }
    
    func testInteract_DeletePlan_Success() async {
        await load()
        let result = await sut.interact(with: .deletePlan(id: WorkoutFixtures.myPlanId))
        
        var routines = WorkoutFixtures.loadedRoutines
        routines.plans.removeValue(forKey: WorkoutFixtures.myPlanId)
        let expectedDomain = HomeDomain(routines: routines)
        
        XCTAssertEqual(result, .loaded(expectedDomain))
        XCTAssertTrue(mockService.saveRoutinesCalled)
        XCTAssertEqual(mockService.numWorkoutHistoryDeleted, 2)
    }
    
    func testInteract_ToggleDialog_NoSavedDomain_Error() async {
        let result = await sut.interact(with: .toggleDialog(type: .deleteWorkout(id: WorkoutFixtures.legWorkoutId),
                                                            isOpen: true))
        
        XCTAssertEqual(result, .error)
    }
    
    func testInteract_ToggleDialog_Success() async {
        let dialogs: [HomeDialog] = [
            .deleteWorkout(id: WorkoutFixtures.legWorkoutId),
            .deletePlan(id: WorkoutFixtures.myPlanId)
        ]
        
        for dialog in dialogs {
            await load()
            var result = await sut.interact(with: .toggleDialog(type: dialog, isOpen: true))
            let expectedDomain = HomeDomain(routines: WorkoutFixtures.loadedRoutines)
            
            XCTAssertEqual(result, .dialog(type: dialog, domain: expectedDomain))
            
            result = await sut.interact(with: .toggleDialog(type: dialog, isOpen: false))
            
            XCTAssertEqual(result, .loaded(expectedDomain))
        }
    }
}

// MARK: - Private

private extension HomeInteractorTests {
    @discardableResult
    func load() async -> HomeDomainResult {
        return await sut.interact(with: .load)
    }
}
