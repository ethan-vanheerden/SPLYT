//
//  WorkoutDetailsReducerTests.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 7/28/23.
//

import XCTest
@testable import SPLYT
@testable import ExerciseCore

final class WorkoutDetailsReducerTests: XCTestCase {
    typealias Fixtures = WorkoutDetailsFixtures
    typealias WorkoutFixtures = WorkoutModelFixtures
    private var interactor: WorkoutDetailsInteractor!
    private var sut: WorkoutDetailsReducer!

    override func setUpWithError() throws {
        self.interactor = WorkoutDetailsInteractor(service: MockWorkoutDetailsService(),
                                                   historyId: WorkoutFixtures.fullBodyWorkoutHistoryId)
        self.sut = WorkoutDetailsReducer()
    }
    
    func testReduce_Error() {
        let result = sut.reduce(.error)
        XCTAssertEqual(result, .error)
    }
    
    func testReduce_Loaded() async {
        let domain = await load()
        let result = sut.reduce(domain)
        
        let expectedDisplay = Fixtures.display()
        
        XCTAssertEqual(result, .loaded(expectedDisplay))
    }
    
    func testReduce_Dialog() async {
        let dialogs: [WorkoutDetailsDialog] = [
            .delete
        ]
        
        for dialog in dialogs {
            await load()
            let domain = await interactor.interact(with: .toggleDialog(dialog: dialog, isOpen: true))
            let result = sut.reduce(domain)
            
            let expectedDisplay = Fixtures.display(presentedDialog: dialog)
            
            XCTAssertEqual(result, .loaded(expectedDisplay))
        }
    }
    
    func testReduce_Exist() async {
        await load()
        let domain = await interactor.interact(with: .delete)
        let result = sut.reduce(domain)
        
        let expectedDisplay = Fixtures.display()
        
        XCTAssertEqual(result, .exit(expectedDisplay))
    }
}

// MARK: - Private

private extension WorkoutDetailsReducerTests {
    @discardableResult
    func load() async  -> WorkoutDetailsDomainResult {
        return await interactor.interact(with: .load)
    }
}
