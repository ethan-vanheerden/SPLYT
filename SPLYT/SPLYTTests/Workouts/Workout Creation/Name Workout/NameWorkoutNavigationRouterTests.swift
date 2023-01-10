//
//  NameWorkoutNavigationRouterTests.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 1/10/23.
//

import XCTest
@testable import SPLYT
import Mocking
import SwiftUI

final class NameWorkoutNavigationRouterTests: XCTestCase {
    private var sut: NameWorkoutNavigationRouter!
    private var mockNavigator: MockNavigator!

    override func setUp() {
        sut = NameWorkoutNavigationRouter()
        mockNavigator = MockNavigator()
        sut.navigator = mockNavigator
    }
    
    func testNavigate_Next() {
        let navState = NameWorkoutNavigationState(workoutName: "Test")
        sut.navigate(.next(navState))
        
        let expectedVC = UIHostingController<AddExerciseView>.self
        XCTAssertTrue(mockNavigator.stubPushedVC?.isKind(of: expectedVC) ?? false)
    }
}
