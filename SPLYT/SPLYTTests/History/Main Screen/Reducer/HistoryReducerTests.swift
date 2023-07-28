//
//  HistoryReducerTests.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 7/21/23.
//

import XCTest
@testable import SPLYT
@testable import DesignSystem
@testable import ExerciseCore

final class HistoryReducerTests: XCTestCase {
    typealias Fixtures = HistoryFixtures
    typealias WorkoutFixtures = WorkoutModelFixtures
    private var interactor: HistoryInteractor!
    private var sut: HistoryReducer!

    override func setUpWithError() throws {
        self.interactor = HistoryInteractor(service: MockHistoryService())
        self.sut = HistoryReducer()
    }
    
    func testReduce_Error() {
        let result = sut.reduce(.error)
        XCTAssertEqual(result, .error)
    }
    
    func testReduce_Loaded() async {
        let domain = await interactor.interact(with: .load)
        let result = sut.reduce(domain)
        
        let expectedDisplay = HistoryDisplay(workouts: Fixtures.histories,
                                             presentedDialog: nil,
                                             deleteWorkoutHistoryDialog: Fixtures.deleteWorkoutHistoryDialog)
        
        XCTAssertEqual(result, .loaded(expectedDisplay))
    }
    
    func testReduce_Dialog() async {
        let dialogs: [HistoryDialog] = [
            .deleteWorkoutHistory(historyId: WorkoutFixtures.legWorkoutHistoryId)
        ]
        
        for dialog in dialogs {
            _ = await interactor.interact(with: .load)
            let domain = await interactor.interact(with: .toggleDialog(dialog: dialog, isOpen: true))
            let result = sut.reduce(domain)
            
            let expectedDisplay = HistoryDisplay(workouts: Fixtures.histories,
                                                 presentedDialog: dialog,
                                                 deleteWorkoutHistoryDialog: Fixtures.deleteWorkoutHistoryDialog)
            
            XCTAssertEqual(result, .loaded(expectedDisplay))
        }
    }
}
