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
    private let navState = NameWorkoutNavigationState(name: "Test")

    override func setUp() {
        let mockService = MockBuildWorkoutService()
        sut = NameWorkoutNavigationRouter(buildWorkoutService: mockService)
        mockNavigator = MockNavigator()
        sut.navigator = mockNavigator
    }
    
    func testNavigate_Next_BuildWorkout() {
        sut.navigate(.next(type: .workout, navState: navState))
        
        let expectedVC = UIHostingController<BuildWorkoutView<BuildWorkoutViewModel>>.self
        XCTAssertTrue(mockNavigator.stubPushedVC?.isKind(of: expectedVC) ?? false)
    }
    
    func testNavigate_Next_BuildPlan() {
        sut.navigate(.next(type: .plan, navState: navState))
        
        let expectedVC = UIHostingController<BuildPlanView<BuildPlanViewModel>>.self
        XCTAssertTrue(mockNavigator.stubPushedVC?.isKind(of: expectedVC) ?? false)
    }
}
