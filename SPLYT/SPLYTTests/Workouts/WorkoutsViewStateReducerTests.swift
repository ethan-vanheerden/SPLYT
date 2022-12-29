//
//  WorkoutsViewStateReducerTests.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 12/29/22.
//

import XCTest
@testable import SPLYT

final class WorkoutsViewStateReducerTests: XCTestCase {
    private let sut = WorkoutsViewStateReducer()
    private let fixtures = WorkoutsFixtures.self
    
    func testReduce_Error() {
        let viewState = sut.reduce(.error)
        XCTAssertEqual(viewState, .error)
    }
    
    func testReduce_Loaded() {
        let viewState = sut.reduce(.loaded([]))
        XCTAssertEqual(viewState, .main(fixtures.mainDisplay))
    }
}
