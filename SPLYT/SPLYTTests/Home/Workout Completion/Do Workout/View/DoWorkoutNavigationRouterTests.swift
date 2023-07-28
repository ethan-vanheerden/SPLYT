//
//  DoWorkoutNavigationRouterTests.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 6/12/23.
//

import XCTest
@testable import SPLYT
import Mocking
import SwiftUI
@testable import ExerciseCore

final class DoWorkoutNavigationRouterTests: XCTestCase {
    typealias WorkoutFixtures = WorkoutModelFixtures
    private var mockNavigator: MockNavigator!
    private var sut: DoWorkoutNavigationRouter!
    private var backExpectation: XCTestExpectation!

    override func setUpWithError() throws {
        mockNavigator = MockNavigator()
        let mockService = MockDoWorkoutService()
        let interactor = DoWorkoutInteractor(workoutId: WorkoutFixtures.legWorkoutId,
                                             service: mockService)
        backExpectation = XCTestExpectation(description: "Navigated back")
        sut = DoWorkoutNavigationRouter(viewModel: DoWorkoutViewModel(interactor: interactor)) { [weak self] in
            self?.backExpectation.fulfill() // Ensures we know the back action was called
        }
        sut.navigator = mockNavigator
    }
    
    func testNavigate_Back() {
        sut.navigate(.back)
        wait(for: [backExpectation], timeout: 1)
    }
    
    func testNavigate_Exit() {
        sut.navigate(.exit)
        XCTAssertTrue(mockNavigator.calledDismiss)
    }
    
    func testNavigate_BeginWorkout() {
        sut.navigate(.beginWorkout)
        
        let expectedVC = UIHostingController<DoWorkoutView<DoWorkoutViewModel>>.self
        XCTAssertTrue(mockNavigator.stubPushedVC?.isKind(of: expectedVC) ?? false)
    }
}
