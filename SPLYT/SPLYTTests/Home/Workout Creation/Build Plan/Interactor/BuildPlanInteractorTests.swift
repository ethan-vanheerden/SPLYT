//
//  BuildPlanInteractorTests.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 7/15/23.
//

import XCTest
@testable import SPLYT
@testable import ExerciseCore

final class BuildPlanInteractorTests: XCTestCase {
    typealias WorkoutFixtures = WorkoutModelFixtures
    private var mockService: MockBuildPlanService!
    private var sut: BuildPlanInteractor!
    
    override func setUpWithError() throws {
        mockService = MockBuildPlanService()
        sut = BuildPlanInteractor(service: mockService,
                                  nameState: .init(name: WorkoutFixtures.myPlanName),
                                  creationDate: WorkoutFixtures.jan_1_2023_0800)
    }
    
    func testInteract_HandleLoad_Success() async {
        let result = await sut.interact(with: .load)
        
        let expectedDomain = BuildPlanDomain(builtPlan: WorkoutFixtures.myPlanEmpty,
                                             canSave: false)
        
        XCTAssertEqual(result, .loaded(expectedDomain))
    }
    
    func testInteract_AddWorkout_NoSavedDomain_Error() async {
        let result = await sut.interact(with: .addWorkout(workout: WorkoutFixtures.legWorkout))
        XCTAssertEqual(result, .error)
    }
    
    func testInteract_AddWorkout_Success() async {
        await load()
        let result = await sut.interact(with: .addWorkout(workout: WorkoutFixtures.legWorkout))
        
        var plan = WorkoutFixtures.myPlanEmpty
        var workout = WorkoutFixtures.legWorkout
        workout.planName = WorkoutFixtures.myPlanName
        plan.workouts.append(workout)
        
        let expectedDomain = BuildPlanDomain(builtPlan: plan,
                                             canSave: true)
        
        XCTAssertEqual(result, .loaded(expectedDomain))
    }
    
    func testInteract_RemoveWorkout_NoSavedDomain_Error() async {
        let result = await sut.interact(with: .removeWorkout(workoutId: WorkoutFixtures.legWorkoutId))
        XCTAssertEqual(result, .error)
    }
    
    func testInteract_RemoveWorkout_Success() async {
        await load()
        _ = await sut.interact(with: .addWorkout(workout: WorkoutFixtures.legWorkout)) // Add so we can remove it
        let result = await sut.interact(with: .removeWorkout(workoutId: WorkoutFixtures.legWorkoutId))
        
        let expectedDomain = BuildPlanDomain(builtPlan: WorkoutFixtures.myPlanEmpty,
                                             canSave: false)
        
        XCTAssertEqual(result, .loaded(expectedDomain))
    }
    
    func testInteract_SavePlan_NoSavedDomain_Error() async {
        let result = await sut.interact(with: .savePlan)
        XCTAssertEqual(result, .error)
        XCTAssertFalse(mockService.savePlanCalled)
    }
    
    func testInteract_SavePlan_ServiceError() async {
        await load()
        mockService.savePlanThrow = true
        let result = await sut.interact(with: .savePlan)
        
        XCTAssertEqual(result, .error)
        XCTAssertTrue(mockService.savePlanCalled)
    }
    
    func testInteract_SavePlan_Success() async {
        await load()
        _ = await sut.interact(with: .addWorkout(workout: WorkoutFixtures.legWorkout))
        let result = await sut.interact(with: .savePlan)
        
        var plan = WorkoutFixtures.myPlanEmpty
        var workout = WorkoutFixtures.legWorkout
        workout.planName = WorkoutFixtures.myPlanName
        plan.workouts.append(workout)
        
        let expectedDomain = BuildPlanDomain(builtPlan: plan,
                                             canSave: true)
        
        XCTAssertEqual(result, .exit(expectedDomain))
        XCTAssertTrue(mockService.savePlanCalled)
    }
    
    func testInteract_ToggleDialog_NoSavedDomain_Error() async {
        let result = await sut.interact(with: .toggleDialog(dialog: .back, isOpen: true))
        XCTAssertEqual(result, .error)
    }
    
    func testInteract_ToggleDialog_Success() async {
        let dialogs: [BuildPlanDialog] = [
            .back,
            .save,
            .deleteWorkout(id: WorkoutFixtures.legWorkoutId)
        ]
        
        for dialog in dialogs {
            await load()
            var result = await sut.interact(with: .toggleDialog(dialog: dialog, isOpen: true)) // Open
            
            let expectedDomain = BuildPlanDomain(builtPlan: WorkoutFixtures.myPlanEmpty,
                                                 canSave: false)
            
            XCTAssertEqual(result, .dialog(dialog: dialog, domain: expectedDomain))
            
            result = await sut.interact(with: .toggleDialog(dialog: dialog, isOpen: false)) // Close
            
            XCTAssertEqual(result, .loaded(expectedDomain))
        }
    }
}

// MARK: - Private

private extension BuildPlanInteractorTests {
    func load() async {
        _ = await sut.interact(with: .load)
    }
}
