//
//  HistoryViewModelTests.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 7/23/23.
//

import XCTest
@testable import SPLYT
@testable import DesignSystem
@testable import ExerciseCore

final class HistoryViewModelTests: XCTestCase {
    typealias Fixtures = HistoryFixtures
    typealias WorkoutFixtures = WorkoutModelFixtures
    private var mockService: MockHistoryService!
    private var sut: HistoryViewModel!
    
    override func setUpWithError() throws {
        self.mockService = MockHistoryService()
        let interactor = HistoryInteractor(service: mockService)
        self.sut = HistoryViewModel(interactor: interactor)
    }
    
    func testLoadingOnInit() {
        XCTAssertEqual(sut.viewState, .loading)
    }
    
    func testSend_Error() async {
        mockService.loadHistoryThrow = true
        await sut.send(.load)
        XCTAssertEqual(sut.viewState, .error)
    }
    
    func testSend_Load() async {
        await sut.send(.load)
        
        let expectedDisplay = HistoryDisplay(workouts: Fixtures.histories,
                                             presentedDialog: nil,
                                             deleteWorkoutHistoryDialog: Fixtures.deleteWorkoutHistoryDialog)
        
        XCTAssertEqual(sut.viewState, .loaded(expectedDisplay))
    }
    
    func testSend_DeleteWorkoutHistory() async {
        await sut.send(.load)
        await sut.send(.deleteWorkoutHistory(historyId: WorkoutFixtures.legWorkoutHistoryId))
        
        var histories = Fixtures.histories
        histories.remove(at: 0)
        
        let expectedDisplay = HistoryDisplay(workouts: histories,
                                             presentedDialog: nil,
                                             deleteWorkoutHistoryDialog: Fixtures.deleteWorkoutHistoryDialog)
        
        XCTAssertEqual(sut.viewState, .loaded(expectedDisplay))
    }
    
    func testSend_ToggleDialog() async {
        let dialogs: [HistoryDialog] = [
            .deleteWorkoutHistory(historyId: WorkoutFixtures.legWorkoutHistoryId)
        ]
        
        for dialog in dialogs {
            await sut.send(.load)
            await sut.send(.toggleDialog(dialog: dialog, isOpen: true))
            
            var expectedDisplay = HistoryDisplay(workouts: Fixtures.histories,
                                                 presentedDialog: dialog,
                                                 deleteWorkoutHistoryDialog: Fixtures.deleteWorkoutHistoryDialog)
            
            XCTAssertEqual(sut.viewState, .loaded(expectedDisplay))
            
            await sut.send(.toggleDialog(dialog: dialog, isOpen: false))
            
            expectedDisplay = HistoryDisplay(workouts: Fixtures.histories,
                                             presentedDialog: nil,
                                             deleteWorkoutHistoryDialog: Fixtures.deleteWorkoutHistoryDialog)
            
            XCTAssertEqual(sut.viewState, .loaded(expectedDisplay))
        }
    }
}
