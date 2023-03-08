//
//  BuildWorkoutNavigationRouterTests.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 3/6/23.
//

import XCTest
@testable import SPLYT
import Mocking
import SwiftUI

final class BuildWorkoutNavigationRouterTests: XCTestCase {
    private var mockNavigator: MockNavigator!
    private var sut: BuildWorkoutNavigationRouter!
    
    override func setUpWithError() throws {
        sut = BuildWorkoutNavigationRouter()
        mockNavigator = MockNavigator()
        sut.navigator = mockNavigator
    }

    func testNavigate_Exit() {
        sut.navigate(.exit)
        XCTAssertTrue(mockNavigator.calledDismissSelf)
    }
}
