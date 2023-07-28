//
//  WorkoutDetailsViewModelTests.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 7/28/23.
//

import XCTest
@testable import SPLYT
@testable import ExerciseCore

final class WorkoutDetailsViewModelTests: XCTestCase {
    typealias Fixtures = WorkoutDetailsFixtures
    typealias WorkoutFixtures = WorkoutModelFixtures
    private var mockService: MockWorkoutDetailsService!
    private var sut: WorkoutDetailsViewModel!

    override func setUpWithError() throws {
        self.mockService = MockWorkoutDetailsService()
        let interactor = WorkoutDetailsInteractor(service: self.mockService,
                                                   historyId: WorkoutFixtures.fullBodyWorkoutHistoryId)
        self.sut = WorkoutDetailsViewModel(interactor: interactor)
    }
    
    func testLoadingOnInit() {
        XCTAssertEqual(sut.viewState, .loading)
    }
    
    func testSend_Error() async {
        mockService.loadWorkoutThrow = true
        await sut.send(.load)
        XCTAssertEqual(sut.viewState, .error)
    }
    
    func testSend_Load() async {
        await sut.send(.load)
        
        let expectedDisplay = Fixtures.display()
        
        XCTAssertEqual(sut.viewState, .loaded(expectedDisplay))
    }
    
    func testSend_ToggleGroupExpand() async {
        await sut.send(.load)
        await sut.send(.toggleGroupExpand(group: 1, isExpanded: false))
        
        let expectedDisplay = Fixtures.display(expandedGroups: [true, false])
        
        XCTAssertEqual(sut.viewState, .loaded(expectedDisplay))
    }
    
    func testSend_ToggleDialog() async {
        let dialogs: [WorkoutDetailsDialog] = [
            .delete
        ]
        
        for dialog in dialogs {
            await sut.send(.load)
            await sut.send(.toggleDialog(dialog: dialog, isOpen: true))
            
            let expectedDisplay = Fixtures.display(presentedDialog: dialog)
            
            XCTAssertEqual(sut.viewState, .loaded(expectedDisplay))
        }
    }
    
    func testSend_Delete() async {
        await sut.send(.load)
        await sut.send(.delete)
        
        let expectedDisplay = Fixtures.display()
        
        XCTAssertEqual(sut.viewState, .exit(expectedDisplay))
    }
}
