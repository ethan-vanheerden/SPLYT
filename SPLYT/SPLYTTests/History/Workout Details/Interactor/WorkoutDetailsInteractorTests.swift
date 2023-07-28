//
//  WorkoutDetailsInteractorTests.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 7/28/23.
//

import XCTest
@testable import SPLYT
@testable import ExerciseCore

final class WorkoutDetailsInteractorTests: XCTestCase {
    typealias WorkoutFixtures = WorkoutModelFixtures
    private var mockService: MockWorkoutDetailsService!
    private var sut: WorkoutDetailsInteractor!
    
    override func setUpWithError() throws {
        self.mockService = MockWorkoutDetailsService()
        self.sut = WorkoutDetailsInteractor(service: mockService,
                                            historyId: WorkoutFixtures.fullBodyWorkoutHistoryId)
    }
    
    func testInteract_Load_ServiceError() async {
        mockService.loadWorkoutThrow = true
        let result = await sut.interact(with: .load)
        
        XCTAssertEqual(result, .error)
        XCTAssertTrue(mockService.loadWorkoutCalled)
    }
    
    func testInteract_Load_Success() async {
        let result = await sut.interact(with: .load)
        
        let expectedDomain = WorkoutDetailsDomain(workout: WorkoutFixtures.fullBodyWorkout,
                                                  expandedGroups: [true, true])
        
        XCTAssertEqual(result, .loaded(expectedDomain))
        XCTAssertTrue(mockService.loadWorkoutCalled)
    }
    
    func testInteract_ToggleGroupExpand_NoSavedDomain_Error() async {
        let result = await sut.interact(with: .toggleGroupExpand(group: 0, isExpanded: false))
        XCTAssertEqual(result, .error)
    }
    
    func testInteract_ToggleGroupExpand_InvalidGroupIndex_Error() async {
        await load()
        let result = await sut.interact(with: .toggleGroupExpand(group: 2, isExpanded: false))
        XCTAssertEqual(result, .error)
    }
    
    func testInteract_ToggleGroupExpand_Success() async {
        await load()
        var result = await sut.interact(with: .toggleGroupExpand(group: 0, isExpanded: false))
        
        var expectedDomain = WorkoutDetailsDomain(workout: WorkoutFixtures.fullBodyWorkout,
                                                  expandedGroups: [false, true])
        
        XCTAssertEqual(result, .loaded(expectedDomain))
        
        _ = await sut.interact(with: .toggleGroupExpand(group: 0, isExpanded: true))
        result = await sut.interact(with: .toggleGroupExpand(group: 1, isExpanded: false))
        
        expectedDomain.expandedGroups = [true, false]
        
        XCTAssertEqual(result, .loaded(expectedDomain))
    }
    
    func testInteract_ToggleDialog_NoSavedDomain_Error() async {
        let result = await sut.interact(with: .toggleDialog(dialog: .delete, isOpen: true))
        XCTAssertEqual(result, .error)
    }
    
    func testInteract_ToggleDialog_Success() async {
        let dialogs: [WorkoutDetailsDialog] = [
            .delete
        ]
        
        for dialog in dialogs {
            await load()
            var result = await sut.interact(with: .toggleDialog(dialog: dialog, isOpen: true))
            
            let expectedDomain = WorkoutDetailsDomain(workout: WorkoutFixtures.fullBodyWorkout,
                                                      expandedGroups: [true, true])
            
            XCTAssertEqual(result, .dialog(dialog: dialog, domain: expectedDomain))
            
            result = await sut.interact(with: .toggleDialog(dialog: dialog, isOpen: false))
            
            XCTAssertEqual(result, .loaded(expectedDomain))
        }
    }
    
    func testInteract_Delete_NoSavedDomain_Error() async {
        let result = await sut.interact(with: .delete)
        XCTAssertEqual(result, .error)
    }
    
    func testInteract_Delete_ServiceError() async {
        mockService.deleteWorkoutHistoryThrow = true
        await load()
        let result = await sut.interact(with: .delete)
        
        XCTAssertEqual(result, .error)
        XCTAssertTrue(mockService.deleteWorkoutHistoryCalled)
    }
    
    func testInteract_Delete_Success() async {
        await load()
        let result = await sut.interact(with: .delete)
        
        let expectedDomain = WorkoutDetailsDomain(workout: WorkoutFixtures.fullBodyWorkout,
                                                  expandedGroups: [true, true])
        
        XCTAssertEqual(result, .exit(expectedDomain))
        XCTAssertTrue(mockService.deleteWorkoutHistoryCalled)
    }
}

// MARK: - Private

private extension WorkoutDetailsInteractorTests {
    func load() async {
        _ = await sut.interact(with: .load)
    }
}
