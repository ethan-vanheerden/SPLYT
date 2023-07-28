//
//  WorkoutDetailsNavigationRouterTests.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 7/28/23.
//

import XCTest
@testable import SPLYT
import Mocking

final class WorkoutDetailsNavigationRouterTests: XCTestCase {
    private var mockNavigator: MockNavigator!
    private var sut: WorkoutDetailsNavigationRouter!

    override func setUpWithError() throws {
        self.mockNavigator = MockNavigator()
        self.sut = WorkoutDetailsNavigationRouter()
        self.sut.navigator = mockNavigator
    }
    
    func testNavigate_Exit() {
        sut.navigate(.exit)
        XCTAssertTrue(mockNavigator.calledDismiss)
    }
}
