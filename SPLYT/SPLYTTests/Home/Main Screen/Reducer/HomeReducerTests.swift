//
//  HomeReducerTests.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 12/29/22.
//

import XCTest
@testable import SPLYT

final class HomeReducerTests: XCTestCase {
    typealias Fixtures = HomeFixtures
    private let sut = HomeReducer()
    private var interactor: HomeInteractor!
    
    override func setUpWithError() throws {
        self.interactor = HomeInteractor(service: MockHomeService())
    }
    
    func testReduce_Error() {
        let result = sut.reduce(.error)
        XCTAssertEqual(result, .error)
    }
    
    func testReduce_Loaded() async {
        let domain = await interactor.interact(with: .load)
        let result = sut.reduce(domain)
        
        let expectedDisplay = HomeDisplay(navBar: Fixtures.navBar,
                                          segmentedControlTitles: Fixtures.segmentedControlTitles,
                                          workouts: Fixtures.createdWorkouts,
                                          fab: Fixtures.fabState,
                                          showDialog: nil,
                                          deleteDialog: Fixtures.deleteDialog)
        
        XCTAssertEqual(result, .main(expectedDisplay))
    }
    
    func testReduce_DeleteDialog() async {
        _ = await interactor.interact(with: .load)
        let domain = await interactor.interact(with: .toggleDialog(type: .deleteWorkout(id: "leg-workout"), isOpen: true))
        let result = sut.reduce(domain)
        
        let expectedDisplay = HomeDisplay(navBar: Fixtures.navBar,
                                          segmentedControlTitles: Fixtures.segmentedControlTitles,
                                          workouts: Fixtures.createdWorkouts,
                                          fab: Fixtures.fabState,
                                          showDialog: .deleteWorkout(id: "leg-workout"),
                                          deleteDialog: Fixtures.deleteDialog)
        
        XCTAssertEqual(result, .main(expectedDisplay))
    }
}
