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
                                          fab: Fixtures.fabState)
        
        XCTAssertEqual(result, .main(expectedDisplay))
    }
}
