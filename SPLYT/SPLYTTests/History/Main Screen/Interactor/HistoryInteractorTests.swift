//
//  HistoryInteractorTests.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 7/21/23.
//

import XCTest
@testable import SPLYT
@testable import ExerciseCore

final class HistoryInteractorTests: XCTestCase {
    typealias WorkoutFixtures = WorkoutModelFixtures
    private var mockService: MockHistoryService!
    private var sut: HistoryInteractor!
    private let legWorkoutHistoryId = WorkoutFixtures.legWorkoutHistoryId

    override func setUpWithError() throws {
        self.mockService = MockHistoryService()
        self.sut = HistoryInteractor(service: mockService)
    }
    
    func testInteract_Load_ServiceError() async {
        mockService.loadHistoryThrow = true
        let result = await sut.interact(with: .load)
        
        XCTAssertEqual(result, .error)
    }
    
    func testInteract_Load_Success() async {
        let result = await sut.interact(with: .load)
        
        let expectedDomain = HistoryDomain(workouts: WorkoutFixtures.workoutHistories)
        
        XCTAssertEqual(result, .loaded(expectedDomain))
    }
    
    func testInteract_DeleteWorkoutHistory_NoSavedDomain_Error() async {
        let result = await sut.interact(with: .deleteWorkoutHistory(historyId: legWorkoutHistoryId))
        XCTAssertEqual(result, .error)
    }
    
    func testInteract_DeleteWorkoutHistory_ServiceError() async {
        await load()
        mockService.deleteHistoryThrow = true
        let result = await sut.interact(with: .deleteWorkoutHistory(historyId: legWorkoutHistoryId))
        
        XCTAssertEqual(result, .error)
        XCTAssertTrue(mockService.deleteHistoryCalled)
    }
    
    func testInteract_DeleteWorkoutHistory_Success() async {
        await load()
        let result = await sut.interact(with: .deleteWorkoutHistory(historyId: legWorkoutHistoryId))
        
        let expectedHistories = [WorkoutFixtures.fullBodyWorkout_WorkoutHistory]
        let expectedDomain = HistoryDomain(workouts: expectedHistories)
        
        XCTAssertEqual(result, .loaded(expectedDomain))
        XCTAssertTrue(mockService.deleteHistoryCalled)
    }
    
    func testInteract_ToggleDialog_NoSavedDomain_Error() async {
        let result = await sut.interact(with: .toggleDialog(dialog: .deleteWorkoutHistory(historyId: legWorkoutHistoryId),
                                                            isOpen: true))
        XCTAssertEqual(result, .error)
    }
    
    func testInteract_ToggleDialog_Success() async {
        let dialogs: [HistoryDialog] = [
            .deleteWorkoutHistory(historyId: legWorkoutHistoryId)
        ]
        
        for dialog in dialogs {
            await load()
            var result = await sut.interact(with: .toggleDialog(dialog: dialog, isOpen: true))
            
            let expectedDomain = HistoryDomain(workouts: WorkoutFixtures.workoutHistories)
            
            XCTAssertEqual(result, .dialog(type: dialog, domain: expectedDomain))
            
            result = await sut.interact(with: .toggleDialog(dialog: dialog, isOpen: false))
            
            XCTAssertEqual(result, .loaded(expectedDomain))
        }
    }
}

// MARK: - Private

private extension HistoryInteractorTests {
    func load() async {
        _ = await sut.interact(with: .load)
    }
}
